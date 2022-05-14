//
//  PackageResolved.swift
//  SwiftPackageListCommand
//
//  Created by Felix Herrmann on 15.03.22.
//

import Foundation

// MARK: - Version

enum PackageResolvedVersion: Int {
    case v1 = 1
    case v2
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
