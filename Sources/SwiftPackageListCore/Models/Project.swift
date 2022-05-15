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
        case .xcodeproj(let fileURL): return fileURL
        case .xcworkspace(let fileURL): return fileURL
        }
    }
    
    public var packageResolvedFileURL: URL {
        switch self {
        case .xcodeproj(let fileURL):
            return fileURL.appendingPathComponent("project.xcworkspace/xcshareddata/swiftpm/Package.resolved")
        case .xcworkspace(let fileURL):
            return fileURL.appendingPathComponent("xcshareddata/swiftpm/Package.resolved")
        }
    }
}

extension Project {
    
    public func checkoutsDirectory(in derivedDataPath: String) throws -> URL? {
        let derivedDataDirectories = try FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath: derivedDataPath), includingPropertiesForKeys: [.isDirectoryKey], options: [.skipsHiddenFiles])
        
        for derivedDataDirectory in derivedDataDirectories {
            let projectFiles = try FileManager.default.contentsOfDirectory(at: derivedDataDirectory, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles])
            guard let infoDotPlist = projectFiles.first(where: { $0.lastPathComponent == "info.plist" }) else { continue }
            let infoPlistData = try Data(contentsOf: infoDotPlist)
            let infoPlist = try PropertyListDecoder().decode(InfoPlist.self, from: infoPlistData)
            if infoPlist.WorkspacePath == fileURL.path {
                let checkoutsDirectory = derivedDataDirectory.appendingPathComponent("/SourcePackages/checkouts")
                return checkoutsDirectory
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
            case .xcodeproj(let fileURL):
                projectFileURL = fileURL
            case .xcworkspace(let fileURL):
                let contentsURL = fileURL.appendingPathComponent("contents.xcworkspacedata")
                let contentsString = try String(contentsOf: contentsURL)
                let locations = try regex("(?<=location = \"group:).*(?=\")", on: contentsString).filter { !$0.contains("Pods.xcodeproj") }
                guard let firstLocation = locations.first else {
                    return nil
                }
                projectFileURL = fileURL.deletingLastPathComponent().appendingPathComponent(firstLocation)
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
        return matches.map { String(fileContent[Range($0.range, in: fileContent)!]) }
    }
}
