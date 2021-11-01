//
//  Models.swift
//  SwiftPackageList
//
//  Created by Felix Herrmann on 01.11.21.
//

import Foundation


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


// MARK: - Package

struct Package: Encodable {
    let name: String
    let version: String?
    let branch: String?
    let repositoryURL: URL
    let license: String?
}
