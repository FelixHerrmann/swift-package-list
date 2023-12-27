//
//  SwiftPackageList+OutputOptions.swift
//  swift-package-list
//
//  Created by Felix Herrmann on 27.12.23.
//

import Foundation
import ArgumentParser
import SwiftPackageListCore

extension SwiftPackageList {
    struct OutputOptions: ParsableArguments {
        @Option(help: "The type of output for the package-list. Available options are json, plist, settings-bundle and pdf.")
        var outputType: OutputType = .stdout
        
        @Option(help: "The path where the package-list file will be stored.")
        var outputPath: String?
        
        @Option(help: "A custom filename to be used instead of the default ones.")
        var customFileName: String?
        
        @Flag(help: "Will skip the packages without a license-file.")
        var requiresLicense = false
    }
}

extension SwiftPackageList.OutputOptions {
    var outputGeneratorOptions: OutputGeneratorOptions {
        let outputURL = outputPath.map { URL(fileURLWithPath: $0) }
        return OutputGeneratorOptions(outputURL: outputURL, customFileName: customFileName)
    }
}
