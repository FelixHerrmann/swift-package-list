//
//  Project.swift
//  SwiftPackageListCommand
//
//  Created by Felix Herrmann on 15.03.22.
//

import Foundation

enum Project {
    case xcodeproj(fileURL: URL)
    case xcworkspace(fileURL: URL)
}

extension Project {
    
    init?(path: String) {
        let fileURL = URL(fileURLWithPath: path)
        switch fileURL.pathExtension {
        case "xcodeproj":
            self = .xcodeproj(fileURL: fileURL)
        case "xcworkspace":
            self = .xcworkspace(fileURL: fileURL)
        default:
            return nil
        }
    }
}

extension Project {
    
    var fileURL: URL {
        switch self {
        case .xcodeproj(let fileURL): return fileURL
        case .xcworkspace(let fileURL): return fileURL
        }
    }
    
    var packageDotResolvedFileURL: URL {
        switch self {
        case .xcodeproj(let fileURL):
            return fileURL.appendingPathComponent("project.xcworkspace/xcshareddata/swiftpm/Package.resolved")
        case .xcworkspace(let fileURL):
            return fileURL.appendingPathComponent("xcshareddata/swiftpm/Package.resolved")
        }
    }
}

extension Project {
    
    func findOrganizationName() -> String? {
        do {
            let projectFileURL: URL
            switch self {
            case .xcodeproj(let fileURL):
                projectFileURL = fileURL
            case .xcworkspace(let fileURL):
                let contentsURL = fileURL.appendingPathComponent("contents.xcworkspacedata")
                let contentsString = try String(contentsOf: contentsURL)
                let contentsRegex = try NSRegularExpression(pattern: "(?<=location = \"group:).*(?=\")")
                let locationMatches = contentsRegex.matches(in: contentsString, range: NSRange(location: 0, length: contentsString.count))
                let locationResults = locationMatches
                    .map { String(contentsString[Range($0.range, in: contentsString)!]) }
                    .filter { !$0.contains("Pods.xcodeproj") }
                guard let firstLocation = locationResults.first else {
                    return nil
                }
                projectFileURL = fileURL.deletingLastPathComponent().appendingPathComponent(firstLocation)
            }
            
            let projectURL = projectFileURL.appendingPathComponent("project.pbxproj")
            let projectString = try String(contentsOf: projectURL)
            let projectRegex = try NSRegularExpression(pattern: "(?<=ORGANIZATIONNAME = \").*(?=\";)")
            let organizationMatches = projectRegex.matches(in: projectString, range: NSRange(location: 0, length: projectString.count))
            let organizationResults = organizationMatches.map { String(projectString[Range($0.range, in: projectString)!]) }
            
            return organizationResults.first
        } catch {
            print("Warning: Could not find the organization name in your project")
            return nil
        }
    }
}
