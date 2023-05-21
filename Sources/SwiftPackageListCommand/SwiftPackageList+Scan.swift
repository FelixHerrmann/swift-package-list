//
//  SwiftPackageList+Scan.swift
//  SwiftPackageListCommand
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
            
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted
            let jsonData = try jsonEncoder.encode(packages)
            let jsonString = String(decoding: jsonData, as: UTF8.self)
            print(jsonString)
        }
    }
}
