//
//  Package.swift
//  SwiftPackageList
//
//  Created by Felix Herrmann on 11.03.23.
//

import Foundation

/// A package object in the package-list file.
public struct Package: Sendable, Hashable, Codable {
    
    /// The kind of package.
    public let kind: Kind
    
    /// The package identity based on it's source location.
    public let identity: String
    
    /// The name of the package.
    public let name: String
    
    /// The version of the package.
    ///
    /// Could be `nil` if the package's dependency-rule is branch or commit.
    public let version: String?
    
    /// The name of the branch.
    ///
    /// Could be `nil` if the package's dependency-rule is version or commit.
    public let branch: String?
    
    /// The exact revision/commit.
    ///
    /// Could be `nil` if the package is located in a registry.
    public let revision: String?
    
    /// The location of the package.
    ///
    /// It can be a local file-path, repository URL and also empty in case of a registry package.
    public let location: String
    
    /// The license text.
    ///
    /// This is always present if the `--requires-license` flag is parsed on command execution.
    public let license: String?
    
    public init(
        kind: Kind,
        identity: String,
        name: String,
        version: String?,
        branch: String?,
        revision: String?,
        location: String,
        license: String?
    ) {
        self.kind = kind
        self.identity = identity
        self.name = name
        self.version = version
        self.branch = branch
        self.revision = revision
        self.location = location
        self.license = license
    }
}

extension Package {
    /// A boolean indicating if the package has a license.
    public var hasLicense: Bool {
        return license != nil
    }
}

// MARK: - Deprecations

extension Package {
    /// The URL to the git-repository.
    @available(*, deprecated, renamed: "location", message: "The assumption that this is always a URL was wrong, it is not the case for registry packages; use location instead.") // swiftlint:disable:this line_length
    public var repositoryURL: URL {
        return URL(string: location) ?? URL(fileURLWithPath: "/")
    }
    
    /// Create a package with the repositoryURL.
    @available(*, deprecated, renamed: "location", message: "The assumption that repositoryURL is always a URL was wrong, it is not the case for registry packages; use the initializer with location instead.") // swiftlint:disable:this line_length
    public init(
        identity: String,
        name: String,
        version: String?,
        branch: String?,
        revision: String?,
        repositoryURL: URL,
        license: String?
    ) {
        self.init(
            kind: Kind(rawValue: ""),
            identity: identity,
            name: name,
            version: version,
            branch: branch,
            revision: revision,
            location: repositoryURL.absoluteString,
            license: license
        )
    }
}

extension Package {
    /// Create a package without ``kind``.
    @available(*, deprecated, message: "There is a new kind property introduced; use the initializer with the kind parameter instead.") // swiftlint:disable:this line_length
    public init(
        identity: String,
        name: String,
        version: String?,
        branch: String?,
        revision: String?,
        location: String,
        license: String?
    ) {
        self.init(
            kind: Kind(rawValue: ""),
            identity: identity,
            name: name,
            version: version,
            branch: branch,
            revision: revision,
            location: location,
            license: license
        )
    }
}
