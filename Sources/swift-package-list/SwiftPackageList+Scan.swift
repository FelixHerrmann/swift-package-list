//
//  SwiftPackageList+Scan.swift
//  swift-package-list
//
//  Created by Felix Herrmann on 21.05.23.
//

import Foundation
import ArgumentParser
import SwiftPackageListCore

extension SwiftPackageList {
    struct Scan: ParsableCommand {
        static var configuration: CommandConfiguration {
            return CommandConfiguration(abstract: "Print all packages as JSON to the console.")
        }
        
        @OptionGroup var options: Options
        
        mutating func run() throws {
            guard let project = Project(path: options.projectPath) else {
                throw ValidationError("The project file is not an Xcode Project or Workspace")
            }
            
            guard FileManager.default.fileExists(atPath: project.packageResolvedFileURL.path) else {
                throw CleanExit.message("This project has no Swift-Package dependencies")
            }
            
            let sourcePackagesDirectory: URL
            if let sourcePackagesPath = options.sourcePackagesPath {
                sourcePackagesDirectory = URL(fileURLWithPath: sourcePackagesPath)
            } else {
                guard let buildDirectory = try project.buildDirectory(in: options.derivedDataPath) else {
                    throw RuntimeError("No build-directory found in your DerivedData-folder")
                }
                sourcePackagesDirectory = buildDirectory.appendingPathComponent("SourcePackages")
            }
            guard FileManager.default.fileExists(atPath: sourcePackagesDirectory.path) else {
                throw RuntimeError("No SourcePackages-directory found")
            }
            
            let packageResolved = try PackageResolved(fileURL: project.packageResolvedFileURL)
            let packages = try packageResolved.packages(in: sourcePackagesDirectory, requiresLicense: options.requiresLicense)
            
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let jsonData = try jsonEncoder.encode(packages)
            let jsonString = String(decoding: jsonData, as: UTF8.self)
            print(jsonString)
        }
    }
}
