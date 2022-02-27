//
//  PackageList.swift
//  SwiftPackageList
//
//  Created by Felix Herrmann on 02.11.21.
//

import Foundation

/// This function reads and decodes the `package-list.json` or `package-list.plist` file in the specified bundle.
///
/// Make sure that the file is part of your project/target.
/// - Parameter bundle: The bundle where the file is stored. Default's to `Bundle.main`.
/// - Throws: A `PackageListError.noPackageList` when no file is located in the bundle.
/// - Throws: A generic error when something goes wrong when reading the file or decoding the file's data.
/// - Returns: An array of ``Package``s.
public func packageList(bundle: Bundle = .main) throws -> [Package] {
    if let path = bundle.path(forResource: "package-list", ofType: "json") {
        let packageListData = try Data(contentsOf: URL(fileURLWithPath: path))
        let packageList = try JSONDecoder().decode([Package].self, from: packageListData)
        return packageList
    } else if let path = bundle.path(forResource: "package-list", ofType: "plist") {
        let packageListData = try Data(contentsOf: URL(fileURLWithPath: path))
        let packageList = try PropertyListDecoder().decode([Package].self, from: packageListData)
        return packageList
    } else {
        throw PackageListError.noPackageList
    }
}
