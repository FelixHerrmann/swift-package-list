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
    
    var projectPbxproj: ProjectPbxproj? {
        let url = fileURL.appendingPathComponent("project.pbxproj")
        return ProjectPbxproj(url: url)
    }
}
