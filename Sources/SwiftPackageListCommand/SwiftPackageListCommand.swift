//
//  SwiftPackageListCommand.swift
//  SwiftPackageListCommand
//
//  Created by Felix Herrmann on 01.11.21.
//

import Foundation
import ArgumentParser
import SwiftPackageListCore

@main
struct SwiftPackageListCommand: ParsableCommand {
    
    static var configuration: CommandConfiguration {
        return CommandConfiguration(version: "2.0.1")
    }
    
    @Argument(help: "The path to your .xcodeproj or .xcworkspace file.")
    var projectPath: String
    
    @Option(name: .shortAndLong, help: "The path to your DerivedData-folder.")
    var derivedDataPath = "\(NSHomeDirectory())/Library/Developer/Xcode/DerivedData"
    
    @Option(name: .shortAndLong, help: "The path to the SourcePackages-folder.")
    var sourcePackagesPath: String?
    
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
        
        guard FileManager.default.fileExists(atPath: project.packageResolvedFileURL.path) else {
            throw CleanExit.message("This project has no Swift-Package dependencies")
        }
        
        let checkoutsDirectory: URL
        if let sourcePackagesPath = sourcePackagesPath {
            checkoutsDirectory = URL(fileURLWithPath: sourcePackagesPath).appendingPathComponent("checkouts")
        } else {
            guard let buildDirectory = try project.buildDirectory(in: derivedDataPath) else {
                throw RuntimeError("No build-directory found in your DerivedData-folder")
            }
            checkoutsDirectory = buildDirectory.appendingPathComponent("/SourcePackages/checkouts")
        }
        guard FileManager.default.fileExists(atPath: checkoutsDirectory.path) else {
            throw RuntimeError("No checkouts-directory found in your SourcePackages-folder")
        }
        
        let packageResolved = try PackageResolved(at: project.packageResolvedFileURL)
        let packages = try packageResolved.packages(in: checkoutsDirectory, requiresLicense: requiresLicense)
        
        let outputURL = fileType.outputURL(at: outputPath, customFileName: customFileName)
        let outputGenerator = fileType.outputGenerator(outputURL: outputURL, packages: packages, project: project)
        try outputGenerator.generateOutput()
        throw CleanExit.message("Generated \(outputURL.path)")
    }
}
