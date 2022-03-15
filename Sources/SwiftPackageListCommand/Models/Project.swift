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
