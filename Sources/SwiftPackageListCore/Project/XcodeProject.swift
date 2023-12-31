//
//  XcodeProject.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 21.12.23.
//

import Foundation

struct XcodeProject: Project {
    let fileURL: URL
    let options: ProjectOptions
    
    var packageResolvedFileURL: URL {
        return fileURL
            .appendingPathComponent("project.xcworkspace")
            .appendingPathComponent("xcshareddata")
            .appendingPathComponent("swiftpm")
            .appendingPathComponent("Package.resolved")
    }
    
    var projectPbxprojFileURL: URL? {
        return fileURL.appendingPathComponent("project.pbxproj")
    }
}
