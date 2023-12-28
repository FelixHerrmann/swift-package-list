//
//  ProjectType.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 26.12.23.
//

import Foundation

public enum ProjectType {
    case xcodeProject
    case xcodeWorkspace
}

extension ProjectType {
    public init(fileURL: URL) throws {
        switch fileURL.pathExtension {
        case "xcodeproj":
            self = .xcodeProject
        case "xcworkspace":
            self = .xcodeWorkspace
        default:
            throw RuntimeError("\(fileURL.lastPathComponent) is not supported")
        }
    }
}

extension ProjectType {
    public func project(fileURL: URL, options: ProjectOptions = ProjectOptions()) -> any Project {
        switch self {
        case .xcodeProject:
            return XcodeProject(fileURL: fileURL, options: options)
        case .xcodeWorkspace:
            return XcodeWorkspace(fileURL: fileURL, options: options)
        }
    }
}
