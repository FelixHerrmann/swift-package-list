//
//  SwiftPackageList+OutputOptions.swift
//  swift-package-list
//
//  Created by Felix Herrmann on 27.12.23.
//

import Foundation
import ArgumentParser
import SwiftPackageList
import SwiftPackageListCore

extension SwiftPackageList {
    struct OutputOptions: ParsableArguments {
        @Option(help: "The type of output for the package-list.")
        var outputType: OutputType = .stdout
        
        @Option(
            help: "The path where the package-list file will be stored. (Not required for stdout output-type)",
            completion: .directory
        )
        var outputPath: String?
        
        @Option(help: "A custom filename to be used instead of the default ones.")
        var customFileName: String?
        
        @Option(help: "The order in which the packages will be listed.")
        var packageOrder: PackageOrder = .source
        
        @Flag(help: "Will skip the packages without a license-file.")
        var requiresLicense = false
        
        @Option(
            name: .customLong("ignore-package"),
            help: ArgumentHelp(
                "Will skip a package with the specified identity. (This option may be repeated multiple times)",
                valueName: "package-identity"
            )
        )
        var ignoredPackageIdentities: [String] = []
    }
}

extension SwiftPackageList.OutputOptions {
    enum PackageOrder: String, CaseIterable, ExpressibleByArgument {
        case source
        case nameAscending = "name-ascending"
        case nameDescending = "name-descending"
        case identityAscending = "identity-ascending"
        case identityDescending = "identity-descending"
    }
}

extension SwiftPackageList.OutputOptions {
    var outputGeneratorOptions: OutputGeneratorOptions {
        let outputURL = outputPath.map { URL(fileURLWithPath: $0) }
        return OutputGeneratorOptions(outputURL: outputURL, customFileName: customFileName)
    }
}

extension SwiftPackageList.OutputOptions {
    func filter(package: Package) -> Bool {
        if requiresLicense && !package.hasLicense { return false }
        return !ignoredPackageIdentities.contains(package.identity)
    }
    
    func sort(lhs: Package, rhs: Package) -> Bool {
        switch packageOrder {
        case .source:
            return false
        case .nameAscending:
            return lhs.name.lowercased() < rhs.name.lowercased()
        case .nameDescending:
            return lhs.name.lowercased() > rhs.name.lowercased()
        case .identityAscending:
            return lhs.identity.lowercased() < rhs.identity.lowercased()
        case .identityDescending:
            return lhs.identity.lowercased() > rhs.identity.lowercased()
        }
    }
}
