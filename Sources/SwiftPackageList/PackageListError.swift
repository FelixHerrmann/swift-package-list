//
//  PackageListError.swift
//  SwiftPackageList
//
//  Created by Felix Herrmann on 11.03.23.
//

/// The possible thrown errors of the `packageList(bundle:fileName:)` function.
public enum PackageListError: Error {
    
    /// Couldn't find a package-list file in the specified bundle for the specified file name.
    case noPackageList
}
