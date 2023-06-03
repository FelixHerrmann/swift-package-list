//
//  SwiftPackageList+Options.swift
//  swift-package-list
//
//  Created by Felix Herrmann on 21.05.23.
//

import Foundation
import ArgumentParser

extension SwiftPackageList {
    struct Options: ParsableArguments {
        @Argument(help: "The path to your .xcodeproj or .xcworkspace file.")
        var projectPath: String
        
        @Option(name: .shortAndLong, help: "The path to your DerivedData-folder.")
        var derivedDataPath = "\(NSHomeDirectory())/Library/Developer/Xcode/DerivedData"
        
        @Option(name: .shortAndLong, help: "The path to a custom SourcePackages-folder.")
        var sourcePackagesPath: String?
        
        @Flag(help: "Will skip the packages without a license-file.")
        var requiresLicense = false
    }
}
