//
//  SwiftPackageListCommand.swift
//  SwiftPackageListCommand
//
//  Created by Felix Herrmann on 01.11.21.
//

import Foundation
import ArgumentParser
import SwiftPackageList

// MARK: - Main

@main
struct SwiftPackageListCommand: ParsableCommand {
    
    static var configuration: CommandConfiguration {
        return CommandConfiguration(version: "1.6.0")
    }
    
    @Argument(help: "The path to your .xcodeproj or .xcworkspace file.")
    var projectPath: String
    
    @Option(name: .shortAndLong, help: "The path to your DerivedData-folder.")
    var derivedDataPath = "\(NSHomeDirectory())/Library/Developer/Xcode/DerivedData"
    
    @Option(name: .shortAndLong, help: "The path where the package-list file will be stored.")
    var outputPath: String = "\(NSHomeDirectory())/Desktop"
    
    @Option(name: .shortAndLong, help: "The file type of the generated package-list file. Available options are json, plist, settings-bundle and pdf.")
    var fileType: FileType = .json
    
    @Option(name: .shortAndLong, help: "A custom filename to be used instead of the default ones.")
    var customFileName: String?
    
    @Flag(help: "Will skip the packages without a license-file.")
    var requiresLicense: Bool = false
    
    mutating func run() throws {
        guard let project = Project(path: projectPath) else {
            throw ValidationError("The project file is not an Xcode Project or Workspace")
        }
        
        guard let checkoutsPath = try locateCheckoutsPath(project: project) else {
            throw RuntimeError("No checkouts-path found in your DerivedData-folder")
        }
        
        guard FileManager.default.fileExists(atPath: project.packageDotResolvedFileURL.path) else {
            throw CleanExit.message("This project has no Swift-Package dependencies")
        }
        let packageDotResolved = try Data(contentsOf: project.packageDotResolvedFileURL)
        
        let packages = try createPackages(from: packageDotResolved, checkoutsPath: checkoutsPath)
        try writeOutputFile(for: packages, project: project)
    }
    
    func createPackages(from packageDotResolved: Data, checkoutsPath: URL) throws -> [Package] {
        let packageDotResolvedJSON = try JSONSerialization.jsonObject(with: packageDotResolved) as? [String: Any]
        let version = packageDotResolvedJSON?["version"] as? Int
        let packageResolvedVersion = PackageResolvedVersion(rawValue: version ?? 0)
        
        switch packageResolvedVersion {
        case .v1:
            let packageResolved = try JSONDecoder().decode(PackageResolved_V1.self, from: packageDotResolved)
            let packages = try packageResolved.object.pins.compactMap { pin -> Package? in
                guard let checkoutURL = pin.checkoutURL else { return nil }
                let name = checkoutURL.lastPathComponent
                if let licensePath = try locateLicensePath(for: checkoutURL, in: checkoutsPath) {
                    let license = try String(contentsOf: licensePath, encoding: .utf8)
                    return Package(name: name, version: pin.state.version, branch: pin.state.branch, revision: pin.state.revision, repositoryURL: checkoutURL, license: license)
                } else if !requiresLicense {
                    return Package(name: name, version: pin.state.version, branch: pin.state.branch, revision: pin.state.revision, repositoryURL: checkoutURL, license: nil)
                }
                return nil
            }
            return packages
        case .v2:
            let packageResolved = try JSONDecoder().decode(PackageResolved_V2.self, from: packageDotResolved)
            let packages = try packageResolved.pins.compactMap { pin -> Package? in
                guard let checkoutURL = pin.checkoutURL else { return nil }
                let name = checkoutURL.lastPathComponent
                if let licensePath = try locateLicensePath(for: checkoutURL, in: checkoutsPath) {
                    let license = try String(contentsOf: licensePath, encoding: .utf8)
                    return Package(name: name, version: pin.state.version, branch: pin.state.branch, revision: pin.state.revision, repositoryURL: checkoutURL, license: license)
                } else if !requiresLicense {
                    return Package(name: name, version: pin.state.version, branch: pin.state.branch, revision: pin.state.revision, repositoryURL: checkoutURL, license: nil)
                }
                return nil
            }
            return packages
        case .none:
            throw RuntimeError("The version of the Package.resolved is not supported")
        }
    }
    
    func writeOutputFile(for packages: [Package], project: Project) throws {
        let fileName = customFileName ?? fileType.defaultFileName
        let outputURL = URL(fileURLWithPath: outputPath)
            .appendingPathComponent(fileName)
            .appendingPathExtension(fileType.fileExtension)
        let outputGenerator = fileType.outputGenerator(outputURL: outputURL, packages: packages, project: project)
        try outputGenerator.generateOutput()
        throw CleanExit.message("Generated \(outputURL.path)")
    }
}

// MARK: - Locate Files

extension SwiftPackageListCommand {
    
    func locateCheckoutsPath(project: Project) throws -> URL? {
        let derivedDataDirectories = try FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath: derivedDataPath), includingPropertiesForKeys: [.isDirectoryKey], options: [.skipsHiddenFiles])
        
        for derivedDataDirectory in derivedDataDirectories {
            let projectFiles = try FileManager.default.contentsOfDirectory(at: derivedDataDirectory, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles])
            guard let infoDotPlist = projectFiles.first(where: { $0.lastPathComponent == "info.plist" }) else { continue }
            let infoPlistData = try Data(contentsOf: infoDotPlist)
            let infoPlist = try PropertyListDecoder().decode(InfoPlist.self, from: infoPlistData)
            if infoPlist.WorkspacePath == project.fileURL.path {
                let checkoutsPath = derivedDataDirectory.appendingPathComponent("/SourcePackages/checkouts")
                return checkoutsPath
            }
        }
        
        return nil
    }

    func locateLicensePath(for checkoutURL: URL, in checkoutsDirectory: URL) throws -> URL? {
        let checkoutName = checkoutURL.lastPathComponent
        let checkoutPath = checkoutsDirectory.appendingPathComponent(checkoutName)
        let packageFiles = try FileManager.default.contentsOfDirectory(at: checkoutPath, includingPropertiesForKeys: [.isRegularFileKey, .localizedNameKey], options: .skipsHiddenFiles)
        
        for packageFile in packageFiles {
            if packageFile.deletingPathExtension().lastPathComponent.lowercased() == "license" {
                return packageFile
            }
        }
        
        return nil
    }
}
