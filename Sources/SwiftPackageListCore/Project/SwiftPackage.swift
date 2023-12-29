//
//  SwiftPackage.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 28.12.23.
//

import Foundation

public struct SwiftPackage: Project {
    public let fileURL: URL
    public let options: ProjectOptions
    
    public var workspaceURL: URL {
        return fileURL.deletingLastPathComponent()
    }
    
    public var packageResolvedFileURL: URL {
        return workspaceURL.appendingPathComponent("Package.resolved")
    }
    
    public var projectPbxprojFileURL: URL? {
        return nil
    }
}
