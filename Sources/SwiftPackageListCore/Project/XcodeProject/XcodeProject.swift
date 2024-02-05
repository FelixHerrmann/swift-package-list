//
//  XcodeProject.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 21.12.23.
//

import Foundation

struct XcodeProject: NativeProject {
    let fileURL: URL
    let options: ProjectOptions
    
    var name: String {
        return fileURL
            .deletingPathExtension()
            .lastPathComponent
    }
    
    var organizationName: String? {
        let url = fileURL.appendingPathComponent("project.pbxproj")
        let projectPbxproj = ProjectPbxproj(url: url)
        return projectPbxproj.organizationName
    }
    
    var workspaceURL: URL {
        return fileURL
    }
    
    var packageResolved: PackageResolved {
        get throws {
            let url = fileURL
                .appendingPathComponent("project.xcworkspace")
                .appendingPathComponent("xcshareddata")
                .appendingPathComponent("swiftpm")
                .appendingPathComponent("Package.resolved")
            return try PackageResolved(url: url)
        }
    }
}
