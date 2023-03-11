//
//  Package.swift
//  SwiftPackageList
//
//  Created by Felix Herrmann on 11.03.23.
//

import Foundation

/// A package object in the package-list file.
public struct Package: Hashable, Codable {
    
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
    /// This is always present, regardless if the package's dependency-rule is version or branch.
    public let revision: String
    
    /// The URL to the git-repository.
    public let repositoryURL: URL
    
    /// The license text.
    ///
    /// This is always present if the `--requires-license` flag is parsed on command execution.
    public let license: String?
    
    public init(name: String, version: String?, branch: String?, revision: String, repositoryURL: URL, license: String?) {
        self.name = name
        self.version = version
        self.branch = branch
        self.revision = revision
        self.repositoryURL = repositoryURL
        self.license = license
    }
}
