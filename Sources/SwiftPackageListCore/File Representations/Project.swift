//
//  Project.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 15.03.22.
//

import Foundation

public enum Project {
    case xcodeproj(fileURL: URL)
    case xcworkspace(fileURL: URL)
}

extension Project {
    public init?(path: String) {
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
        case .xcodeproj(fileURL: let fileURL): return fileURL
        case .xcworkspace(fileURL: let fileURL): return fileURL
        }
    }
    
    public var packageResolvedFileURL: URL {
        switch self {
        case .xcodeproj(fileURL: let fileURL):
            return fileURL.appendingPathComponent("project.xcworkspace/xcshareddata/swiftpm/Package.resolved")
        case .xcworkspace(fileURL: let fileURL):
            return fileURL.appendingPathComponent("xcshareddata/swiftpm/Package.resolved")
        }
    }
}

extension Project {
    private struct InfoPlist: Decodable {
        let workspacePath: String
        
        enum CodingKeys: String, CodingKey {
            case workspacePath = "WorkspacePath"
        }
    }
    
    public func buildDirectory(in derivedDataPath: String) throws -> URL? {
        let buildDirectories = try FileManager.default.contentsOfDirectory(
            at: URL(fileURLWithPath: derivedDataPath),
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        )
        
        for buildDirectory in buildDirectories {
            let buildFiles = try FileManager.default.contentsOfDirectory(
                at: buildDirectory,
                includingPropertiesForKeys: [.isRegularFileKey],
                options: [.skipsHiddenFiles]
            )
            guard let infoDotPlist = buildFiles.first(where: { $0.lastPathComponent == "info.plist" }) else { continue }
            let infoPlistData = try Data(contentsOf: infoDotPlist)
            let infoPlist = try PropertyListDecoder().decode(InfoPlist.self, from: infoPlistData)
            if infoPlist.workspacePath == fileURL.path {
                return buildDirectory
            }
        }
        
        return nil
    }
}

extension Project {
    func findOrganizationName() -> String? {
        do {
            let projectFileURL: URL
            switch self {
            case .xcodeproj(fileURL: let fileURL):
                projectFileURL = fileURL
            case .xcworkspace(fileURL: let fileURL):
                let contentsURL = fileURL.appendingPathComponent("contents.xcworkspacedata")
                let contentsString = try String(contentsOf: contentsURL)
                let locations = try regex("(?<=location = \"group:).*(?=\")", on: contentsString)
                guard let firstNonPodsLocation = locations.first(where: { !$0.contains("Pods.xcodeproj") }) else {
                    print("Warning: Could not find the organization name in your project")
                    return nil
                }
                projectFileURL = fileURL.deletingLastPathComponent().appendingPathComponent(firstNonPodsLocation)
            }
            
            let projectURL = projectFileURL.appendingPathComponent("project.pbxproj")
            let projectString = try String(contentsOf: projectURL)
            let organizationNames = try regex("(?<=ORGANIZATIONNAME = \").*(?=\";)", on: projectString)
            if organizationNames.isEmpty {
                let organizationNamesWithoutQuotes = try regex("(?<=ORGANIZATIONNAME = ).*(?=;)", on: projectString)
                return organizationNamesWithoutQuotes.first
            } else {
                return organizationNames.first
            }
        } catch {
            print("Warning: Could not find the organization name in your project")
            return nil
        }
    }
    
    private func regex(_ pattern: String, on fileContent: String) throws -> [String] {
        let regex = try NSRegularExpression(pattern: pattern)
        let matches = regex.matches(in: fileContent, range: NSRange(location: 0, length: fileContent.count))
        return matches.compactMap { result in
            guard let range = Range(result.range, in: fileContent) else { return nil }
            return String(fileContent[range])
        }
    }
}
