//
//  SwiftPackageList.swift
//  swift-package-list
//
//  Created by Felix Herrmann on 01.11.21.
//

import Foundation
import ArgumentParser
import SwiftPackageList
import SwiftPackageListCore

@main
struct SwiftPackageList: ParsableCommand {
    static var configuration: CommandConfiguration {
        return CommandConfiguration(
            discussion: "A command-line tool to get all used Swift Package dependencies.",
            version: "3.1.0"
        )
    }
    
    @OptionGroup var inputOptions: InputOptions
    @OptionGroup var outputOptions: OutputOptions
    
    mutating func run() throws {
        let projectFileURL = URL(fileURLWithPath: inputOptions.projectPath)
        let projectType = try ProjectType(fileURL: projectFileURL)
        let project = try projectType.project(fileURL: projectFileURL, options: inputOptions.projectOptions)
        
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
