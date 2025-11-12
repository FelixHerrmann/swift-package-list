//
//  SwiftPackage.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 28.12.23.
//

import Foundation

struct SwiftPackage: NativeProject {
    let fileURL: URL
    let options: ProjectOptions
    
    var name: String {
        return fileURL
            .deletingLastPathComponent()
            .lastPathComponent
    }
    
    var workspaceURL: URL {
        return fileURL.deletingLastPathComponent()
    }
    
    var packageResolved: PackageResolved {
        get throws {
            let url = workspaceURL.appendingPathComponent("Package.resolved")
            return try PackageResolved(url: url)
        }
    }
    
    var configuration: Configuration? {
        let url = workspaceURL
            .appendingPathComponent(".swiftpm")
            .appendingPathComponent("configuration")
        return Configuration(url: url)
    }
}
