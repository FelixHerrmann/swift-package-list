//
//  Package+Kind.swift
//  SwiftPackageList
//
//  Created by Felix Herrmann on 01.03.25.
//

extension Package {
    /// The specific kind of a package.
    public struct Kind: Sendable, RawRepresentable {
        public let rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}

// MARK: - Conformances

extension Package.Kind: Equatable { }
extension Package.Kind: Hashable { }
extension Package.Kind: Decodable { }
extension Package.Kind: Encodable { }

// MARK: - Known Values

extension Package.Kind {
    /// A local source package.
    public static let localSourceControl = Self(rawValue: "localSourceControl")
    
    /// A remote source package.
    public static let remoteSourceControl = Self(rawValue: "remoteSourceControl")
    
    /// A package from  a registry.
    public static let registry = Self(rawValue: "registry")
}
