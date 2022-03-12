//
//  Models.swift
//  SwiftPackageListCommand
//
//  Created by Felix Herrmann on 01.11.21.
//

import Foundation
import ArgumentParser


// MARK: - Errors

struct RuntimeError: Error, CustomStringConvertible {
    let description: String
    
    init(_ description: String) {
        self.description = description
    }
}


// MARK: - PackageResolved

struct PackageResolved: Decodable {
    let object: Object
}

extension PackageResolved {
    
    struct Object: Decodable {
        let pins: [Pin]
    }
}

extension PackageResolved.Object {
    
    struct Pin: Decodable {
        let package: String
        let repositoryURL: String
        let state: State
    }
}

extension PackageResolved.Object.Pin {
    
    struct State: Decodable {
        let branch: String?
        let revision: String
        let version: String?
    }
}

extension PackageResolved.Object.Pin {
    
    var checkoutURL: URL? {
        URL(string: repositoryURL.replacingOccurrences(of: ".git", with: ""))
    }
}


// MARK: - InfoPlist

struct InfoPlist: Decodable {
    let WorkspacePath: String
}


// MARK: - FileType

enum FileType: String, CaseIterable, ExpressibleByArgument {
    case json
    case plist
}


// MARK: - Project

enum Project {
    case xcodeproj(fileURL: URL)
    case xcworkspace(fileURL: URL)
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
