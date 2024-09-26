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
            version: "4.3.0"
        )
    }
    
    @OptionGroup var inputOptions: InputOptions
    @OptionGroup var outputOptions: OutputOptions
    
    mutating func run() throws {
        let projectFileURL = URL(fileURLWithPath: inputOptions.projectPath)
        let projectType = try ProjectType(fileURL: projectFileURL)
        let project = try projectType.project(fileURL: projectFileURL, options: inputOptions.projectOptions)
        
        let packages = try project.packages().filter(outputOptions.filter)
        
        let outputType = outputOptions.outputType
        let outputGenerator = try outputType.outputGenerator(
            packages: packages,
            project: project,
            options: outputOptions.outputGeneratorOptions
        )
        try outputGenerator.generateOutput()
    }
}

extension SwiftPackageList.OutputOptions {
    func filter(_ isIncluded: Package) -> Bool {
        if requiresLicense, !isIncluded.hasLicense {
            return false
        }
        for baseURL in ignoreBaseURL where isIncluded.repositoryURL.absoluteString.hasPrefix(baseURL) {
            return false
        }
        return true
    }
}
