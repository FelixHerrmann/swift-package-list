//
//  WorkspaceState.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 09.12.23.
//

import Foundation

/// Source: https://github.com/apple/swift-package-manager/blob/d457fa46b396248e46361776faacb9e0020b92d1/Sources/Workspace/Workspace%2BState.swift
public enum WorkspaceState {
    // swiftlint:disable identifier_name
    case v4(WorkspaceState_V4)
    case v5(WorkspaceState_V5)
    case v6(WorkspaceState_V6)
    // swiftlint:enable identifier_name
}

extension WorkspaceState {
    public init(at url: URL) throws {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let version = try decoder.decode(Version.self, from: data)
        
        switch version.version {
        case 1, 2, 3, 4:
            let workspaceState = try decoder.decode(WorkspaceState_V4.self, from: data)
            self = .v4(workspaceState)
        case 5:
            let workspaceState = try decoder.decode(WorkspaceState_V5.self, from: data)
            self = .v5(workspaceState)
        case 6:
            let workspaceState = try decoder.decode(WorkspaceState_V6.self, from: data)
            self = .v6(workspaceState)
        default:
            throw RuntimeError("Version \(version.version) of workspace-state.json is not supported")
        }
    }
}

// MARK: - Package Name

extension WorkspaceState {
    func packageName(for identity: String) -> String? {
        switch self {
        case .v4(let v4): // swiftlint:disable:this identifier_name
            for artifact in v4.object.artifacts where artifact.packageRef.identity == identity {
                return artifact.packageRef.name
            }
            
            for dependency in v4.object.dependencies where dependency.packageRef.identity == identity {
                return dependency.packageRef.name
            }
        case .v5(let v5): // swiftlint:disable:this identifier_name
            for artifact in v5.object.artifacts where artifact.packageRef.identity == identity {
                return artifact.packageRef.name
            }
            
            for dependency in v5.object.dependencies where dependency.packageRef.identity == identity {
                return dependency.packageRef.name
            }
        case .v6(let v6): // swiftlint:disable:this identifier_name
            for artifact in v6.object.artifacts where artifact.packageRef.identity == identity {
                return artifact.packageRef.name
            }
            
            for dependency in v6.object.dependencies where dependency.packageRef.identity == identity {
                return dependency.packageRef.name
            }
        }
        return nil
    }
}

// MARK: - Version

extension WorkspaceState {
    struct Version: Decodable {
        let version: Int
    }
}

// MARK: - v4

public struct WorkspaceState_V4: Decodable {
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

// MARK: - V5

public struct WorkspaceState_V5: Decodable {
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

// MARK: - V6

public struct WorkspaceState_V6: Decodable {
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
