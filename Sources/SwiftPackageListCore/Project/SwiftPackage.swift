//
//  SwiftPackage.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 28.12.23.
//

import Foundation

struct SwiftPackage: Project {
    let fileURL: URL
    let options: ProjectOptions
    
    var workspaceURL: URL {
        return fileURL.deletingLastPathComponent()
    }
    
    var packageResolvedFileURL: URL {
        return workspaceURL.appendingPathComponent("Package.resolved")
    }
    
    var projectPbxprojFileURL: URL? {
        return nil
    }
}
