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
        @Argument(
            help: "The path to your *.xcodeproj, *.xcworkspace, Package.swift, Project.swift or Dependencies.swift file.",
            completion: .file(extensions: ["xcodeproj", "xcworkspace", "swift"])
        )
        var projectPath: String
        
        @Option(help: "A custom path to your DerivedData-folder.", completion: .directory)
        var customDerivedDataPath: String?
        
        @Option(help: "A custom path to the SourcePackages-folder.", completion: .directory)
        var customSourcePackagesPath: String?
        
        @Option(
            name: .customLong("custom-packages-file-path"),
            help: "A path to a file containing custom packages in the same format as the JSON-output. (This option may be repeated multiple times)", // swiftlint:disable:this line_length
            completion: .file(extensions: ["json"])
        )
        var customPackagesFilePaths: [String] = []
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
