//
//  Tuist.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 29.12.23.
//

import Foundation
import SwiftPackageList

struct Tuist: NativeProject {
    let fileURL: URL
    let options: ProjectOptions
    private let dump: Dump
    
    var name: String {
        return dump.name
    }
    
    var organizationName: String? {
        return dump.organizationName
    }
    
    var workspaceURL: URL {
        return fileURL
            .deletingLastPathComponent()
            .appendingPathComponent("\(name).xcworkspace")
    }
    
    var packageResolved: PackageResolved {
        get throws {
            let packageResolvedURL = fileURL
                .deletingLastPathComponent()
                .appendingPathComponent(".package.resolved")
            return try PackageResolved(url: packageResolvedURL)
        }
    }
    
    init(fileURL: URL, options: ProjectOptions) throws {
        self.fileURL = fileURL
        self.options = options
        self.dump = try Tuist.createDump(fileURL: fileURL)
    }
}
