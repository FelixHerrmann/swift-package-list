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
        return CommandConfiguration(version: "1.4.0")
    }
    
    @Argument(help: "The path to your .xcodeproj or .xcworkspace file.")
    var projectPath: String
    
    @Option(name: .shortAndLong, help: "The path to your DerivedData-folder.")
    var derivedDataPath = "\(NSHomeDirectory())/Library/Developer/Xcode/DerivedData"
    
    @Option(name: .shortAndLong, help: "The path where the package-list file will be stored.")
    var outputPath: String = "\(NSHomeDirectory())/Desktop"
    
    @Option(name: .shortAndLong, help: "The file type of the generated package-list file. Available options are json and plist.")
    var fileType: FileType = .json
    
    @Flag(help: "Will skip the packages without a license-file.")
    var requiresLicense: Bool = false
    
    mutating func run() throws {
        guard let project = Project(path: projectPath) else {
            throw RuntimeError("The project file is not an Xcode Project or Workspace")
        }
        
        guard let checkoutsPath = try locateCheckoutsPath(project: project) else {
            throw RuntimeError("No checkouts-path found in your DerivedData-folder")
        }
        
        guard FileManager.default.fileExists(atPath: project.packageDotResolvedFileURL.path) else {
            print("This project has no Swift-Package dependencies")
            return
        }
        let packageDotResolved = try String(contentsOfFile: project.packageDotResolvedFileURL.path)
        let packageResolved = try JSONDecoder().decode(PackageResolved.self, from: Data(packageDotResolved.utf8))
        
        let packages = try packageResolved.object.pins.compactMap { pin -> Package? in
            guard let checkoutURL = pin.checkoutURL else { return nil }
            if let licensePath = try locateLicensePath(for: checkoutURL, in: checkoutsPath) {
                let license = try String(contentsOf: licensePath, encoding: .utf8)
                return Package(name: pin.package, version: pin.state.version, branch: pin.state.branch, revision: pin.state.revision, repositoryURL: checkoutURL, license: license)
            } else if !requiresLicense {
                return Package(name: pin.package, version: pin.state.version, branch: pin.state.branch, revision: pin.state.revision, repositoryURL: checkoutURL, license: nil)
            }
            return nil
        }
        
        try writeOutputFile(for: packages)
    }
    
    func writeOutputFile(for packages: [Package]) throws {
        switch fileType {
        case .json:
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted
            let json = try jsonEncoder.encode(packages)
            try json.write(to: URL(fileURLWithPath: "\(outputPath)/package-list.json"))
            print("Generated package-list.json at \(outputPath)")
        case .plist:
            let plistEncoder = PropertyListEncoder()
            plistEncoder.outputFormat = .xml
            let plist = try plistEncoder.encode(packages)
            try plist.write(to: URL(fileURLWithPath: "\(outputPath)/package-list.plist"))
            print("Generated package-list.plist at \(outputPath)")
        }
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
