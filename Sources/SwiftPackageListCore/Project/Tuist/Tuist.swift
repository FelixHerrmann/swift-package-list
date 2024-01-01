//
//  Tuist.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 29.12.23.
//

import Foundation
import SwiftPackageList

struct Tuist: Project {
    let fileURL: URL
    let options: ProjectOptions
    private let dump: Dump
    
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
                .appendingPathComponent("Tuist")
                .appendingPathComponent("Dependencies")
                .appendingPathComponent("Lockfiles")
                .appendingPathComponent("Package.resolved")
            return try PackageResolved(url: packageResolvedURL)
        }
    }
    
    init(fileURL: URL, options: ProjectOptions) throws {
        self.fileURL = fileURL
        self.options = options
        self.dump = try Self.createDump(fileURL: fileURL)
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
                .appendingPathComponent("Tuist")
                .appendingPathComponent("Dependencies")
                .appendingPathComponent("SwiftPackageManager")
                .appendingPathComponent(".build")
            sourcePackages = SourcePackages(url: sourcePackagesDirectory)
        }
        
        return try packageResolved.packages(in: sourcePackages)
    }
}
