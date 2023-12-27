//
//  SwiftPackageList+Scan.swift
//  swift-package-list
//
//  Created by Felix Herrmann on 21.05.23.
//

import Foundation
import ArgumentParser
import SwiftPackageList
import SwiftPackageListCore

extension SwiftPackageList {
    struct Scan: ParsableCommand {
        static var configuration: CommandConfiguration {
            return CommandConfiguration(abstract: "Print all packages as JSON to the console.")
        }
        
        @OptionGroup var inputOptions: InputOptions
        @OptionGroup var outputOptions: OutputOptions
        
        mutating func run() throws {
            let projectFileURL = URL(fileURLWithPath: inputOptions.projectPath)
            let projectType = try ProjectType(fileURL: projectFileURL)
            let project = projectType.project(fileURL: projectFileURL, options: inputOptions.projectOptions)
            
            let packages: [Package]
            if outputOptions.requiresLicense {
                packages = try project.packages().filter(\.hasLicense)
            } else {
                packages = try project.packages()
            }
            
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let jsonData = try jsonEncoder.encode(packages)
            let jsonString = String(decoding: jsonData, as: UTF8.self)
            print(jsonString)
        }
    }
}
