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
        @Argument(help: "The path to your *.xcodeproj, *.xcworkspace, Package.swift, Project.swift or Dependencies.swift file.")
        var projectPath: String
        
        @Option(help: "A custom path to your DerivedData-folder.")
        var customDerivedDataPath: String?
        
        @Option(help: "A custom path to the SourcePackages-folder.")
        var customSourcePackagesPath: String?
    }
}

extension SwiftPackageList.InputOptions {
    var projectOptions: ProjectOptions {
        return ProjectOptions(
            customDerivedDataPath: customDerivedDataPath,
            customSourcePackagesPath: customSourcePackagesPath
        )
    }
}
