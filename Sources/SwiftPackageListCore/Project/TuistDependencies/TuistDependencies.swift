//
//  TuistDependencies.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 04.02.24.
//

import Foundation
import SwiftPackageList

struct TuistDependencies: Project {
    let fileURL: URL
    let options: ProjectOptions
    private let dump: Tuist.Dump
    
    var name: String {
        return dump.name
    }
    
    var organizationName: String? {
        return dump.organizationName
    }
    
    var packageResolved: PackageResolved {
        get throws {
            let packageResolvedURL = fileURL
                .deletingLastPathComponent()
                .appendingPathComponent("Dependencies")
                .appendingPathComponent("Lockfiles")
                .appendingPathComponent("Package.resolved")
            return try PackageResolved(url: packageResolvedURL)
        }
    }
    
    init(fileURL: URL, options: ProjectOptions) throws {
        self.fileURL = fileURL
        self.options = options
        
        let projectFileURL = fileURL
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Project.swift")
        self.dump = try Tuist.createDump(fileURL: projectFileURL)
    }
    
    func packages() throws -> [Package] {
        let packageResolved = try packageResolved
        
        let sourcePackages: SourcePackages
        if let sourcePackagesPath = options.customSourcePackagesPath {
            let sourcePackagesDirectory = URL(fileURLWithPath: sourcePackagesPath)
            sourcePackages = SourcePackages(url: sourcePackagesDirectory)
        } else {
            let sourcePackagesDirectory = fileURL
                .deletingLastPathComponent()
                .appendingPathComponent("Dependencies")
                .appendingPathComponent("SwiftPackageManager")
                .appendingPathComponent(".build")
            sourcePackages = SourcePackages(url: sourcePackagesDirectory)
        }
        
        return try packageResolved.packages(in: sourcePackages)
    }
}
