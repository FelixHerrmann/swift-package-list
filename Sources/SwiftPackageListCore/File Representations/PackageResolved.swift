//
//  PackageResolved.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 15.03.22.
//

import Foundation
import SwiftPackageList

/// Source: https://github.com/apple/swift-package-manager/blob/d457fa46b396248e46361776faacb9e0020b92d1/Sources/PackageGraph/PinsStore.swift
public enum PackageResolved {
    // swiftlint:disable identifier_name
    case v1(PackageResolved_V1)
    case v2(PackageResolved_V2)
    case v3(PackageResolved_V3)
    // swiftlint:enable identifier_name
}

extension PackageResolved {
    public init(at url: URL) throws {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let version = try decoder.decode(Version.self, from: data)
        
        switch version.version {
        case 1:
            let packageResolved = try decoder.decode(PackageResolved_V1.self, from: data)
            self = .v1(packageResolved)
        case 2:
            let packageResolved = try decoder.decode(PackageResolved_V2.self, from: data)
            self = .v2(packageResolved)
        case 3:
            let packageResolved = try decoder.decode(PackageResolved_V3.self, from: data)
            self = .v3(packageResolved)
        default:
            throw RuntimeError("Version \(version.version) of Package.resolved is not supported")
        }
    }
}

// MARK: - Packages

extension PackageResolved {
    public func packages(in sourcePackagesDirectory: URL, requiresLicense: Bool) throws -> [Package] {
        switch self {
        case .v1(let packageResolved):
            return try packages(
                pins: packageResolved.object.pins,
                sourcePackagesDirectory: sourcePackagesDirectory,
                requiresLicense: requiresLicense
            )
        case .v2(let packageResolved):
            return try packages(
                pins: packageResolved.pins,
                sourcePackagesDirectory: sourcePackagesDirectory,
                requiresLicense: requiresLicense
            )
        case .v3(let packageResolved):
            return try packages(
                pins: packageResolved.pins,
                sourcePackagesDirectory: sourcePackagesDirectory,
                requiresLicense: requiresLicense
            )
        }
    }
    
    private func licensePath(for checkoutURL: URL, in checkoutsDirectory: URL) throws -> URL? {
        let checkoutName = checkoutURL.deletingPathExtension().lastPathComponent
        let checkoutPath = checkoutsDirectory.appendingPathComponent(checkoutName)
        let packageFiles = try FileManager.default.contentsOfDirectory(
            at: checkoutPath,
            includingPropertiesForKeys: [.isRegularFileKey, .localizedNameKey],
            options: .skipsHiddenFiles
        )
        return packageFiles.first { packageFile in
            let fileName = packageFile.deletingPathExtension().lastPathComponent.lowercased()
            let allowedFileNames = ["license", "licence"]
            return allowedFileNames.contains(fileName)
        }
    }
    
    private func packages(
        pins: [PackageResolved_V1.Object.Pin],
        sourcePackagesDirectory: URL,
        requiresLicense: Bool
    ) throws -> [Package] {
        let checkoutsDirectory = sourcePackagesDirectory.appendingPathComponent("checkouts")
        
        return try pins.compactMap { pin -> Package? in
            guard let checkoutURL = pin.checkoutURL else { return nil }
            if let licensePath = try licensePath(for: checkoutURL, in: checkoutsDirectory) {
                let license = try String(contentsOf: licensePath, encoding: .utf8)
                return Package(
                    identity: pin.identity,
                    name: pin.package,
                    version: pin.state.version,
                    branch: pin.state.branch,
                    revision: pin.state.revision,
                    repositoryURL: checkoutURL,
                    license: license
                )
            } else if !requiresLicense {
                return Package(
                    identity: pin.identity,
                    name: pin.package,
                    version: pin.state.version,
                    branch: pin.state.branch,
                    revision: pin.state.revision,
                    repositoryURL: checkoutURL,
                    license: nil
                )
            }
            return nil
        }
    }
    
    private func packages(
        pins: [PackageResolved_V2.Pin],
        sourcePackagesDirectory: URL,
        requiresLicense: Bool
    ) throws -> [Package] {
        let checkoutsDirectory = sourcePackagesDirectory.appendingPathComponent("checkouts")
        let workspaceStateFile = sourcePackagesDirectory.appendingPathComponent("workspace-state.json")
        let workspaceState = try WorkspaceState(at: workspaceStateFile)
        
        return try pins.compactMap { pin -> Package? in
            guard let checkoutURL = pin.checkoutURL else { return nil }
            let name = workspaceState.packageName(for: pin.identity) ?? pin.identity
            
            if let licensePath = try licensePath(for: checkoutURL, in: checkoutsDirectory) {
                let license = try String(contentsOf: licensePath, encoding: .utf8)
                return Package(
                    identity: pin.identity,
                    name: name,
                    version: pin.state.version,
                    branch: pin.state.branch,
                    revision: pin.state.revision,
                    repositoryURL: checkoutURL,
                    license: license
                )
            } else if !requiresLicense {
                return Package(
                    identity: pin.identity,
                    name: name,
                    version: pin.state.version,
                    branch: pin.state.branch,
                    revision: pin.state.revision,
                    repositoryURL: checkoutURL,
                    license: nil
                )
            }
            return nil
        }
    }
}

// MARK: - Version

extension PackageResolved {
    struct Version: Decodable {
        let version: Int
    }
}

// MARK: - V1

public struct PackageResolved_V1: Decodable {
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

extension PackageResolved_V1.Object.Pin {
    var checkoutURL: URL? {
        return URL(string: repositoryURL)
    }
    
    /// Source: https://github.com/apple/swift-package-manager/blob/d457fa46b396248e46361776faacb9e0020b92d1/Sources/PackageModel/PackageIdentity.swift#L304
    var identity: String {
        let url: URL
        if let remoteURL = URL(string: repositoryURL) {
            url = remoteURL
        } else {
            url = URL(fileURLWithPath: repositoryURL)
        }
        return url.deletingPathExtension().lastPathComponent.lowercased()
    }
}

// MARK: - V2

public struct PackageResolved_V2: Decodable {
    struct Pin: Decodable {
        struct State: Decodable {
            let revision: String
            let version: String?
            let branch: String?
        }
        
        let identity: String
        let kind: String
        let location: String
        let state: State
    }
    
    let pins: [Pin]
    let version: Int
}

extension PackageResolved_V2.Pin {
    var checkoutURL: URL? {
        return URL(string: location)
    }
}

// MARK: - V3

public struct PackageResolved_V3: Decodable {
    let pins: [PackageResolved_V2.Pin]
    let originHash: String?
    let version: Int
}
