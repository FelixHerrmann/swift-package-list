//
//  PackageProvider.swift
//  SwiftPackageList
//
//  Created by Felix Herrmann on 02.01.24.
//

/// A type that provides ``Package``s from some arbitrary source.
public protocol PackageProvider: Sendable {
    
    /// Provides the array of packages.
    /// - Returns: An array of ``Package`` objects.
    /// - Throws: This method can throw if something went wrong during the process.
    func packages() throws -> [Package]
}
