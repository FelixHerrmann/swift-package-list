//
//  NativeProject.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 31.12.23.
//

import Foundation
import SwiftPackageList

protocol NativeProject: Project {
    var workspaceURL: URL { get }
    var packageResolved: PackageResolved { get throws }
    var configuration: Configuration? { get }
}

extension NativeProject {
    var configuration: Configuration? {
        return nil
    }
    
    func packages() throws -> [Package] {
        let packageResolved = try packageResolved
        
        let sourcePackages: SourcePackages
        if let sourcePackagesPath = options.customSourcePackagesPath {
            let sourcePackagesDirectory = URL(fileURLWithPath: sourcePackagesPath)
            sourcePackages = SourcePackages(url: sourcePackagesDirectory)
        } else {
            let derivedDataDirectory: URL
            if let derivedDataPath = options.customDerivedDataPath {
                derivedDataDirectory = URL(fileURLWithPath: derivedDataPath)
            } else {
                derivedDataDirectory = DerivedData.defaultDirectory
            }
            let derivedData = DerivedData(url: derivedDataDirectory)
            guard let buildDirectory = try derivedData.buildDirectory(project: self) else {
                throw RuntimeError("No build directory found in \(derivedData.url.path) for project \(fileURL.path)")
            }
            let sourcePackagesDirectory = buildDirectory.appendingPathComponent("SourcePackages")
            sourcePackages = SourcePackages(url: sourcePackagesDirectory)
        }
        
        return try packageResolved.packages(in: sourcePackages, configuration: configuration)
    }
}
