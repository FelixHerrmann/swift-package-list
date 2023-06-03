//
//  SwiftPackageList+Generate.swift
//  swift-package-list
//
//  Created by Felix Herrmann on 21.05.23.
//

import Foundation
import ArgumentParser
import SwiftPackageListCore

extension SwiftPackageList {
    struct Generate: ParsableCommand {
        static var configuration: CommandConfiguration {
            return CommandConfiguration(abstract: "Generate the specified output for all packages.")
        }
        
        @OptionGroup var options: Options
        
        @Option(name: .shortAndLong, help: "The path where the package-list file will be stored.")
        var outputPath = "\(NSHomeDirectory())/Desktop"
        
        // swiftlint:disable:next line_length
        @Option(name: .shortAndLong, help: "The file type of the generated package-list file. Available options are json, plist, settings-bundle and pdf.")
        var fileType: FileType = .json
        
        @Option(name: .shortAndLong, help: "A custom filename to be used instead of the default ones.")
        var customFileName: String?
        
        mutating func run() throws {
            guard let project = Project(path: options.projectPath) else {
                throw ValidationError("The project file is not an Xcode Project or Workspace")
            }
            
            guard FileManager.default.fileExists(atPath: project.packageResolvedFileURL.path) else {
                throw CleanExit.message("This project has no Swift-Package dependencies")
            }
            
            let checkoutsDirectory: URL
            if let sourcePackagesPath = options.sourcePackagesPath {
                checkoutsDirectory = URL(fileURLWithPath: sourcePackagesPath).appendingPathComponent("checkouts")
            } else {
                guard let buildDirectory = try project.buildDirectory(in: options.derivedDataPath) else {
                    throw RuntimeError("No build-directory found in your DerivedData-folder")
                }
                checkoutsDirectory = buildDirectory.appendingPathComponent("/SourcePackages/checkouts")
            }
            guard FileManager.default.fileExists(atPath: checkoutsDirectory.path) else {
                throw RuntimeError("No checkouts-directory found in your SourcePackages-folder")
            }
            
            let packageResolved = try PackageResolved(at: project.packageResolvedFileURL)
            let packages = try packageResolved.packages(in: checkoutsDirectory, requiresLicense: options.requiresLicense)
            
            let outputURL = fileType.outputURL(at: outputPath, customFileName: customFileName)
            let outputGenerator = fileType.outputGenerator(outputURL: outputURL, packages: packages, project: project)
            try outputGenerator.generateOutput()
            throw CleanExit.message("Generated \(outputURL.path)")
        }
    }
}
