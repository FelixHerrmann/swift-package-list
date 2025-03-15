//
//  WorkspaceState.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 09.12.23.
//

import Foundation

// swiftlint:disable identifier_name type_name

/// Source: https://github.com/apple/swift-package-manager/blob/d457fa46b396248e46361776faacb9e0020b92d1/Sources/Workspace/Workspace%2BState.swift
struct WorkspaceState: VersionedFile {
    let url: URL
    let storage: Storage
    
    init(url: URL) throws {
        self.url = url
        self.storage = try Storage(url: url)
    }
}

// MARK: - Storage

extension WorkspaceState {
    enum Storage {
        case v4(V4)
        case v5(V5)
        case v6(V6)
        case v7(V7)
    }
}

extension WorkspaceState.Storage: VersionedFileStorage {
    private struct Version: Decodable {
        let version: Int
    }
    
    init(url: URL) throws {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let version = try decoder.decode(Version.self, from: data)
        
        switch version.version {
        case 1, 2, 3, 4:
            let v4 = try decoder.decode(V4.self, from: data)
            self = .v4(v4)
        case 5:
            let v5 = try decoder.decode(V5.self, from: data)
            self = .v5(v5)
        case 6:
            let v6 = try decoder.decode(V6.self, from: data)
            self = .v6(v6)
        case 7:
            let v7 = try decoder.decode(V7.self, from: data)
            self = .v7(v7)
        default:
            throw RuntimeError("Version \(version.version) of workspace-state.json is not supported")
        }
    }
}

// MARK: - V4

extension WorkspaceState.Storage {
    struct V4: Decodable {
        struct Object: Decodable {
            struct Artifact: Decodable {
                let packageRef: PackageRef
            }
            
            struct Dependency: Decodable {
                let packageRef: PackageRef
            }
            
            struct PackageRef: Decodable {
                let identity: String
                let name: String
            }
            
            let artifacts: [Artifact]
            let dependencies: [Dependency]
        }
        
        let object: Object
        let version: Int
    }
}

// MARK: - V5

extension WorkspaceState.Storage {
    struct V5: Decodable {
        struct Object: Decodable {
            struct Artifact: Decodable {
                let packageRef: PackageRef
            }
            
            struct Dependency: Decodable {
                let packageRef: PackageRef
            }
            
            struct PackageRef: Decodable {
                let identity: String
                let name: String
            }
            
            let artifacts: [Artifact]
            let dependencies: [Dependency]
        }
        
        let object: Object
        let version: Int
    }
}

// MARK: - V6

extension WorkspaceState.Storage {
    struct V6: Decodable {
        struct Object: Decodable {
            struct Artifact: Decodable {
                let packageRef: PackageRef
            }
            
            struct Dependency: Decodable {
                let packageRef: PackageRef
            }
            
            struct PackageRef: Decodable {
                let identity: String
                let name: String
            }
            
            let artifacts: [Artifact]
            let dependencies: [Dependency]
        }
        
        let object: Object
        let version: Int
    }
}

// MARK: - V7

extension WorkspaceState.Storage {
    struct V7: Decodable {
        struct Object: Decodable {
            struct Artifact: Decodable {
                let packageRef: PackageRef
            }
            
            struct Dependency: Decodable {
                let packageRef: PackageRef
            }
            
            struct PackageRef: Decodable {
                let identity: String
                let name: String
            }
            
            let artifacts: [Artifact]
            let dependencies: [Dependency]
        }
        
        let object: Object
        let version: Int
    }
}

// MARK: - Package Name

extension WorkspaceState {
    func packageName(for identity: String) -> String? {
        switch self.storage {
        case .v4(let v4):
            for artifact in v4.object.artifacts where artifact.packageRef.identity == identity {
                return artifact.packageRef.name
            }
            
            for dependency in v4.object.dependencies where dependency.packageRef.identity == identity {
                return dependency.packageRef.name
            }
        case .v5(let v5):
            for artifact in v5.object.artifacts where artifact.packageRef.identity == identity {
                return artifact.packageRef.name
            }
            
            for dependency in v5.object.dependencies where dependency.packageRef.identity == identity {
                return dependency.packageRef.name
            }
        case .v6(let v6):
            for artifact in v6.object.artifacts where artifact.packageRef.identity == identity {
                return artifact.packageRef.name
            }
            
            for dependency in v6.object.dependencies where dependency.packageRef.identity == identity {
                return dependency.packageRef.name
            }
        case .v7(let v7):
            for artifact in v7.object.artifacts where artifact.packageRef.identity == identity {
                return artifact.packageRef.name
            }
            
            for dependency in v7.object.dependencies where dependency.packageRef.identity == identity {
                return dependency.packageRef.name
            }
        }
        return nil
    }
}

// swiftlint:enable identifier_name type_name
