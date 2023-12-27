//
//  SwiftPackageList+Generate.swift
//  swift-package-list
//
//  Created by Felix Herrmann on 21.05.23.
//

import Foundation
import ArgumentParser
import SwiftPackageList
import SwiftPackageListCore

extension SwiftPackageList {
    struct Generate: ParsableCommand {
        static var configuration: CommandConfiguration {
            return CommandConfiguration(abstract: "Generate the specified output for all packages.")
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
            
            let outputType = outputOptions.outputType
            let outputGenerator = try outputType.outputGenerator(
                packages: packages,
                project: project,
                options: outputOptions.outputGeneratorOptions
            )
            try outputGenerator.generateOutput()
        }
    }
}
