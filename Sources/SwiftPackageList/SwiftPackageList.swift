//
//  SwiftPackageList.swift
//  SwiftPackageList
//
//  Created by Felix Herrmann on 01.11.21.
//

import Foundation
import ArgumentParser


// MARK: - Main

@main
struct SwiftPackageList: ParsableCommand {
    
    @Argument(help: "The directory to your .xcodeproj-file.")
    var projectPath: String
    
    @Option(name: .shortAndLong, help: "The directory to your DerivedData-folder.")
    var derivedDataPath = "\(NSHomeDirectory())/Library/Developer/Xcode/DerivedData"
    
    @Option(name: .shortAndLong, help: "The path where the package-list.json-file will be stored.")
    var outputPath: String = "\(NSHomeDirectory())/Desktop"
    
    @Flag(help: "Will skip the packages without a license-file")
    var requiresLicense: Bool = false
    
    mutating func run() throws {
        guard let checkoutsPath = try findCheckoutsPath(projectPath: projectPath) else { return }

        let packageDotResolvedPath = "\(projectPath)/project.xcworkspace/xcshareddata/swiftpm/Package.resolved"
        guard FileManager.default.fileExists(atPath: packageDotResolvedPath) else {
            print("This project has no Swift-Package dependencies")
            return
        }
        let packageDotResolved = try String(contentsOfFile: packageDotResolvedPath)
        let packageResolved = try JSONDecoder().decode(PackageResolved.self, from: Data(packageDotResolved.utf8))

        let packages = try packageResolved.object.pins.compactMap { pin -> Package? in
            guard let checkoutURL = pin.checkoutURL else { return nil }
            if let licensePath = try findLicensePath(for: checkoutURL, in: checkoutsPath) {
                let license = try String(contentsOf: licensePath, encoding: .utf8)
                return Package(name: pin.package, version: pin.state.version, branch: pin.state.branch, repositoryURL: checkoutURL, license: license)
            } else if !requiresLicense {
                return Package(name: pin.package, version: pin.state.version, branch: pin.state.branch, repositoryURL: checkoutURL, license: nil)
            }
            return nil
        }
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        let json = try jsonEncoder.encode(packages)
        try json.write(to: URL(fileURLWithPath: "\(outputPath)/package-list.json"))
    }
}


// MARK: - Find Files

extension SwiftPackageList {
    
    func findCheckoutsPath(projectPath: String) throws -> URL? {
        let derivedDataDirectories = try FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath: derivedDataPath), includingPropertiesForKeys: [.isDirectoryKey], options: [.skipsHiddenFiles])
        
        for derivedDataDirectory in derivedDataDirectories {
            let projectFiles = try FileManager.default.contentsOfDirectory(at: derivedDataDirectory, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles])
            guard let infoDotPlist = projectFiles.first(where: { $0.lastPathComponent == "info.plist" }) else { continue }
            let infoPlistData = try Data(contentsOf: infoDotPlist)
            let infoPlist = try PropertyListDecoder().decode(InfoPlist.self, from: infoPlistData)
            if infoPlist.WorkspacePath == projectPath {
                let checkoutsPath = derivedDataDirectory.appendingPathComponent("/SourcePackages/checkouts")
                return checkoutsPath
            }
        }
        
        return nil
    }

    func findLicensePath(for checkoutURL: URL, in checkoutsDirectory: URL) throws -> URL? {
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
