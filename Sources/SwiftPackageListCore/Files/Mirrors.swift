//
//  Mirrors.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 09.11.25.
//

import Foundation

struct Mirrors: VersionedFile {
    let url: URL
    let storage: Storage
    
    init(url: URL) throws {
        self.url = url
        self.storage = try Storage(url: url)
    }
}

// MARK: - Storage

extension Mirrors {
    enum Storage {
        case v1(V1)
    }
}

extension Mirrors.Storage: VersionedFileStorage {
    private struct Version: Decodable {
        let version: Int
    }
    
    init(url: URL) throws {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let version = try decoder.decode(Version.self, from: data)
        
        switch version.version {
        case 1:
            let v1 = try decoder.decode(V1.self, from: data)
            self = .v1(v1)
        default:
            throw RuntimeError("Version \(version.version) of mirrors.json is not supported")
        }
    }
}

// MARK: - V1

extension Mirrors.Storage {
    struct V1: Decodable {
        struct Object: Decodable {
            let mirror: String
            let original: String
        }
        
        let object: [Object]
        let version: Int
    }
}

// MARK: - Mirror

extension Mirrors {
    func mirror(for location: String) -> String? {
        switch storage {
        case .v1(let v1):
            return v1.object.first(where: { $0.original == location })?.mirror
        }
    }
}
