//
//  PackageList.swift
//  SwiftPackageList
//
//  Created by Felix Herrmann on 02.11.21.
//

import Foundation

/// This function reads and decodes the `package-list.json` file in your bundle.
///
/// Make sure that the `package-list.json` file is part of your project/target.
/// - Parameter bundle: The bundle where the `package-list.json` is stored. Default's to `Bundle.main`.
/// - Throws: A `PackageListError.noPackageList` when no `package-list.json` is located in the bundle.
/// - Throws: A generic error when something goes wrong when reading the file or decoding the file's data.
/// - Returns: An array of ``Package``s.
public func packageList(bundle: Bundle = .main) throws -> [Package] {
    guard let path = bundle.path(forResource: "package-list", ofType: "json") else {
        throw PackageListError.noPackageList
    }
    let packageListData = try Data(contentsOf: URL(fileURLWithPath: path))
    let packageList = try JSONDecoder().decode([Package].self, from: packageListData)
    return packageList
}
