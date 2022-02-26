//
//  Models.swift
//  SwiftPackageListCommand
//
//  Created by Felix Herrmann on 01.11.21.
//

import Foundation
import ArgumentParser


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


// MARK: - InfoPlist

struct InfoPlist: Decodable {
    let WorkspacePath: String
}


// MARK: - FileType

enum FileType: String, CaseIterable, ExpressibleByArgument {
    case json
    case plist
}
