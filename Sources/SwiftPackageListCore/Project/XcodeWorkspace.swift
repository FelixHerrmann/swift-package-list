//
//  XcodeWorkspace.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 21.12.23.
//

import Foundation

public struct XcodeWorkspace: Project {
    public let fileURL: URL
    public let options: ProjectOptions
    
    public var packageResolvedFileURL: URL {
        return fileURL
            .appendingPathComponent("xcshareddata")
            .appendingPathComponent("swiftpm")
            .appendingPathComponent("Package.resolved")
    }
    
    public var projectPbxprojFileURL: URL? {
        let contentsURL = fileURL.appendingPathComponent("contents.xcworkspacedata")
        let locations: [String]
        do {
            let contents = try String(contentsOf: contentsURL)
            locations = try regex("(?<=location = \"group:).*(?=\")", on: contents)
        } catch {
            return nil
        }
        
        guard let firstNonPodsLocation = locations.first(where: { !$0.contains("Pods.xcodeproj") }) else {
            return nil
        }
        return fileURL
            .deletingLastPathComponent()
            .appendingPathComponent(firstNonPodsLocation)
            .appendingPathComponent("project.pbxproj")
    }
}
