//
//  Project.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 15.03.22.
//

import Foundation
import SwiftPackageList

public protocol Project {
    var fileURL: URL { get }
    var options: ProjectOptions { get }
    var workspaceURL: URL { get }
    var packageResolvedFileURL: URL { get }
    var projectPbxprojFileURL: URL? { get }
    
    func packages() throws -> [Package]
}

// MARK: - Default Implementations

extension Project {
    public var workspaceURL: URL {
        return fileURL
    }
    
    public func packages() throws -> [Package] {
        let packageResolved = try PackageResolved(url: packageResolvedFileURL)
        
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
        
        return try packageResolved.packages(in: sourcePackages)
    }
}

// MARK: - Helpers

extension Project {
    var projectPbxproj: ProjectPbxproj? {
        return projectPbxprojFileURL.map { ProjectPbxproj(url: $0) }
    }
}
