//
//  PackageResolved.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 15.03.22.
//

import Foundation
import SwiftPackageList

// swiftlint:disable identifier_name type_name

/// Source: https://github.com/apple/swift-package-manager/blob/d457fa46b396248e46361776faacb9e0020b92d1/Sources/PackageGraph/PinsStore.swift
struct PackageResolved: VersionedFile {
    let url: URL
    let storage: Storage
    
    init(url: URL) throws {
        self.url = url
        self.storage = try Storage(url: url)
    }
}

// MARK: - Storage

extension PackageResolved {
    enum Storage {
        case v1(V1)
        case v2(V2)
        case v3(V3)
    }
}

extension PackageResolved.Storage: VersionedFileStorage {
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
        case 2:
            let v2 = try decoder.decode(V2.self, from: data)
            self = .v2(v2)
        case 3:
            let v3 = try decoder.decode(V3.self, from: data)
            self = .v3(v3)
        default:
            throw RuntimeError("Version \(version.version) of Package.resolved is not supported")
        }
    }
}

// MARK: - V1

extension PackageResolved.Storage {
    struct V1: Decodable {
        struct Object: Decodable {
            struct Pin: Decodable {
                struct State: Decodable {
                    let branch: String?
                    let revision: String
                    let version: String?
                }
                
                let package: String
                let repositoryURL: String
                let state: State
            }
            
            let pins: [Pin]
        }
        
        let object: Object
        let version: Int
    }
}

extension PackageResolved.Storage.V1.Object.Pin {
    /// Source: https://github.com/apple/swift-package-manager/blob/70862aa31255de0b9240826bfddaa1bb92cefb05/Sources/PackageGraph/ResolvedPackagesStore.swift#L528-L532
    var kind: Package.Kind {
        if repositoryURL.starts(with: "/") {
            return .localSourceControl
        } else {
            return .remoteSourceControl
        }
    }
    
    /// Source: https://github.com/apple/swift-package-manager/blob/d457fa46b396248e46361776faacb9e0020b92d1/Sources/PackageModel/PackageIdentity.swift#L304
    var identity: String {
        let url: URL
        if let remoteURL = URL(string: repositoryURL) {
            url = remoteURL
        } else {
            url = URL(fileURLWithPath: repositoryURL)
        }
        return url.packageIdentity.lowercased()
    }
}

// MARK: - V2

extension PackageResolved.Storage {
    struct V2: Decodable {
        struct Pin: Decodable {
            struct State: Decodable {
                let revision: String?
                let version: String?
                let branch: String?
            }
            
            let identity: String
            let kind: Package.Kind
            let location: String
            let state: State
        }
        
        let pins: [Pin]
        let version: Int
    }
}

// MARK: - V3

extension PackageResolved.Storage {
    struct V3: Decodable {
        let pins: [V2.Pin]
        let originHash: String?
        let version: Int
    }
}

// MARK: - Packages

extension PackageResolved {
    func packages(in sourcePackages: SourcePackages) throws -> [Package] {
        switch self.storage {
        case .v1(let packageResolved):
            return try packages(pins: packageResolved.object.pins, sourcePackages: sourcePackages)
        case .v2(let packageResolved):
            return try packages(pins: packageResolved.pins, sourcePackages: sourcePackages)
        case .v3(let packageResolved):
            return try packages(pins: packageResolved.pins, sourcePackages: sourcePackages)
        }
    }
    
    private func packages(
        pins: [PackageResolved.Storage.V1.Object.Pin],
        sourcePackages: SourcePackages
    ) throws -> [Package] {
        let checkouts = sourcePackages.checkouts
        
        return try pins.map { pin -> Package in
            let license = try checkouts.license(location: pin.repositoryURL)
            
            return Package(
                kind: pin.kind,
                identity: pin.identity,
                name: pin.package,
                version: pin.state.version,
                branch: pin.state.branch,
                revision: pin.state.revision,
                location: pin.repositoryURL,
                license: license
            )
        }
    }
    
    private func packages(
        pins: [PackageResolved.Storage.V2.Pin],
        sourcePackages: SourcePackages
    ) throws -> [Package] {
        let checkouts = sourcePackages.checkouts
        let workspaceState = try sourcePackages.workspaceState
        
        return try pins.map { pin -> Package in
            let name = workspaceState.packageName(for: pin.identity) ?? pin.identity
            let license = try checkouts.license(location: pin.location)
            
            return Package(
                kind: pin.kind,
                identity: pin.identity,
                name: name,
                version: pin.state.version,
                branch: pin.state.branch,
                revision: pin.state.revision,
                location: pin.location,
                license: license
            )
        }
    }
}

// swiftlint:enable identifier_name type_name
