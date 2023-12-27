//
//  SwiftPackageList+InputOptions.swift
//  swift-package-list
//
//  Created by Felix Herrmann on 21.05.23.
//

import Foundation
import ArgumentParser
import SwiftPackageListCore

extension SwiftPackageList {
    struct InputOptions: ParsableArguments {
        @Argument(help: "The path to your .xcodeproj or .xcworkspace file.")
        var projectPath: String
        
        @Option(help: "The path to your DerivedData-folder.")
        var derivedDataPath: String?
        
        @Option(help: "The path to a custom SourcePackages-folder.")
        var sourcePackagesPath: String?
    }
}

extension SwiftPackageList.InputOptions {
    var projectOptions: ProjectOptions {
        return ProjectOptions(
            customDerivedDataPath: derivedDataPath,
            customSourcePackagesPath: sourcePackagesPath
        )
    }
}
