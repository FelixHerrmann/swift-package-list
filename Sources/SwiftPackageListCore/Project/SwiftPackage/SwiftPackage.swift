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
    
    var workspaceURL: URL {
        return fileURL.deletingLastPathComponent()
    }
    
    var packageResolved: PackageResolved {
        get throws {
            let url = workspaceURL.appendingPathComponent("Package.resolved")
            return try PackageResolved(url: url)
        }
    }
    
    var projectPbxproj: ProjectPbxproj? {
        return nil
    }
}
