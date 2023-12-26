//
//  XcodeProject.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 21.12.23.
//

import Foundation

public struct XcodeProject: Project {
    public let fileURL: URL
    public let options: ProjectOptions
    
    public var packageResolvedFileURL: URL {
        return fileURL
            .appendingPathComponent("project.xcworkspace")
            .appendingPathComponent("xcshareddata")
            .appendingPathComponent("swiftpm")
            .appendingPathComponent("Package.resolved")
    }
    
    public var projectPbxprojFileURL: URL? {
        return fileURL.appendingPathComponent("project.pbxproj")
    }
}
