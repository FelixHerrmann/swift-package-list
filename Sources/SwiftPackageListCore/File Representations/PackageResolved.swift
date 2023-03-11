//
//  PackageResolved.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 15.03.22.
//

import Foundation
import SwiftPackageList

public enum PackageResolved {
    // swiftlint:disable identifier_name
    case v1(PackageResolved_V1)
    case v2(PackageResolved_V2)
    // swiftlint:enable identifier_name
}

extension PackageResolved {
    public init(at url: URL) throws {
        let packageResolvedData = try Data(contentsOf: url)
        let packageResolvedJSON = try JSONSerialization.jsonObject(with: packageResolvedData) as? [String: Any]
        let version = packageResolvedJSON?["version"] as? Int
        
        switch version {
        case 1:
            let packageResolved = try JSONDecoder().decode(PackageResolved_V1.self, from: packageResolvedData)
            self = .v1(packageResolved)
        case 2:
            let packageResolved = try JSONDecoder().decode(PackageResolved_V2.self, from: packageResolvedData)
            self = .v2(packageResolved)
        default:
            throw RuntimeError("The version of the Package.resolved is not supported")
        }
    }
}

extension PackageResolved {
    public func packages(in checkoutsDirectory: URL, requiresLicense: Bool) throws -> [Package] {
        switch self {
        case .v1(let packageResolved):
            return try packages(v1: packageResolved, checkoutsDirectory: checkoutsDirectory, requiresLicense: requiresLicense)
        case .v2(let packageResolved):
            return try packages(v2: packageResolved, checkoutsDirectory: checkoutsDirectory, requiresLicense: requiresLicense)
        }
    }
    
    private func licensePath(for checkoutURL: URL, in checkoutsDirectory: URL) throws -> URL? {
        let checkoutName = checkoutURL.lastPathComponent
        let checkoutPath = checkoutsDirectory.appendingPathComponent(checkoutName)
        let packageFiles = try FileManager.default.contentsOfDirectory(
            at: checkoutPath,
            includingPropertiesForKeys: [.isRegularFileKey, .localizedNameKey],
            options: .skipsHiddenFiles
        )
        return packageFiles.first { $0.deletingPathExtension().lastPathComponent.lowercased() == "license" }
    }
    
    // swiftlint:disable:next identifier_name
    private func packages(v1: PackageResolved_V1, checkoutsDirectory: URL, requiresLicense: Bool) throws -> [Package] {
        return try v1.object.pins.compactMap { pin -> Package? in
            guard let checkoutURL = pin.checkoutURL else { return nil }
            if let licensePath = try licensePath(for: checkoutURL, in: checkoutsDirectory) {
                let license = try String(contentsOf: licensePath, encoding: .utf8)
                return Package(
                    name: checkoutURL.lastPathComponent,
                    version: pin.state.version,
                    branch: pin.state.branch,
                    revision: pin.state.revision,
                    repositoryURL: checkoutURL,
                    license: license
                )
            } else if !requiresLicense {
                return Package(
                    name: checkoutURL.lastPathComponent,
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
    
    // swiftlint:disable:next identifier_name
    private func packages(v2: PackageResolved_V2, checkoutsDirectory: URL, requiresLicense: Bool) throws -> [Package] {
        return try v2.pins.compactMap { pin -> Package? in
            guard let checkoutURL = pin.checkoutURL else { return nil }
            if let licensePath = try licensePath(for: checkoutURL, in: checkoutsDirectory) {
                let license = try String(contentsOf: licensePath, encoding: .utf8)
                return Package(
                    name: checkoutURL.lastPathComponent,
                    version: pin.state.version,
                    branch: pin.state.branch,
                    revision: pin.state.revision,
                    repositoryURL: checkoutURL,
                    license: license
                )
            } else if !requiresLicense {
                return Package(
                    name: checkoutURL.lastPathComponent,
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
        URL(string: repositoryURL.replacingOccurrences(of: ".git", with: ""))
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
        URL(string: location.replacingOccurrences(of: ".git", with: ""))
    }
}
