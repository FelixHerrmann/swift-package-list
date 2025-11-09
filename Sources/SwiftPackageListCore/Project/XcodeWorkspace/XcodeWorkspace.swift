//
//  XcodeWorkspace.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 21.12.23.
//

import Foundation

struct XcodeWorkspace: NativeProject {
    let fileURL: URL
    let options: ProjectOptions
    
    var name: String {
        return fileURL
            .deletingPathExtension()
            .lastPathComponent
    }
    
    var organizationName: String? {
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
        let url = fileURL
            .deletingLastPathComponent()
            .appendingPathComponent(firstNonPodsLocation)
            .appendingPathComponent("project.pbxproj")
        let projectPbxproj = ProjectPbxproj(url: url)
        
        return projectPbxproj.organizationName
    }
    
    var workspaceURL: URL {
        return fileURL
    }
    
    var packageResolved: PackageResolved {
        get throws {
            let url = fileURL
                .appendingPathComponent("xcshareddata")
                .appendingPathComponent("swiftpm")
                .appendingPathComponent("Package.resolved")
            return try PackageResolved(url: url)
        }
    }
    
    var configuration: Configuration? {
        let url = fileURL
            .appendingPathComponent("xcshareddata")
            .appendingPathComponent("swiftpm")
            .appendingPathComponent("configuration")
        return Configuration(url: url)
    }
}
