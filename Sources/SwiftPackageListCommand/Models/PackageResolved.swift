//
//  PackageResolved.swift
//  SwiftPackageListCommand
//
//  Created by Felix Herrmann on 15.03.22.
//

import Foundation
import SwiftPackageList

enum PackageResolved {
    case v1(PackageResolved_V1)
    case v2(PackageResolved_V2)
}

extension PackageResolved {
    
    init(at url: URL) throws {
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
    
    func packages(in checkoutsDirectory: URL, requiresLicense: Bool) throws -> [Package] {
        switch self {
        case .v1(let packageResolved):
            return try packageResolved.object.pins.compactMap { pin -> Package? in
                guard let checkoutURL = pin.checkoutURL else { return nil }
                let name = checkoutURL.lastPathComponent
                if let licensePath = try licensePath(for: checkoutURL, in: checkoutsDirectory) {
                    let license = try String(contentsOf: licensePath, encoding: .utf8)
                    return Package(name: name, version: pin.state.version, branch: pin.state.branch, revision: pin.state.revision, repositoryURL: checkoutURL, license: license)
                } else if !requiresLicense {
                    return Package(name: name, version: pin.state.version, branch: pin.state.branch, revision: pin.state.revision, repositoryURL: checkoutURL, license: nil)
                }
                return nil
            }
        case .v2(let packageResolved):
            return try packageResolved.pins.compactMap { pin -> Package? in
                guard let checkoutURL = pin.checkoutURL else { return nil }
                let name = checkoutURL.lastPathComponent
                if let licensePath = try licensePath(for: checkoutURL, in: checkoutsDirectory) {
                    let license = try String(contentsOf: licensePath, encoding: .utf8)
                    return Package(name: name, version: pin.state.version, branch: pin.state.branch, revision: pin.state.revision, repositoryURL: checkoutURL, license: license)
                } else if !requiresLicense {
                    return Package(name: name, version: pin.state.version, branch: pin.state.branch, revision: pin.state.revision, repositoryURL: checkoutURL, license: nil)
                }
                return nil
            }
        }
    }
    
    private func licensePath(for checkoutURL: URL, in checkoutsDirectory: URL) throws -> URL? {
        let checkoutName = checkoutURL.lastPathComponent
        let checkoutPath = checkoutsDirectory.appendingPathComponent(checkoutName)
        let packageFiles = try FileManager.default.contentsOfDirectory(at: checkoutPath, includingPropertiesForKeys: [.isRegularFileKey, .localizedNameKey], options: .skipsHiddenFiles)
        
        for packageFile in packageFiles {
            if packageFile.deletingPathExtension().lastPathComponent.lowercased() == "license" {
                return packageFile
            }
        }
        
        return nil
    }
}

// MARK: - V1

struct PackageResolved_V1: Decodable {
    
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

struct PackageResolved_V2: Decodable {
    
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
