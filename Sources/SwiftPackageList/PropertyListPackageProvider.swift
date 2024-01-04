//
//  PropertyListPackageProvider.swift
//  SwiftPackageList
//
//  Created by Felix Herrmann on 02.01.24.
//

import Foundation

/// A package provider for `.plist` package-lists stored in a `Bundle`.
public struct PropertyListPackageProvider: PackageProvider {
    
    /// The bundle to read the Property List file from.
    ///
    /// Default value is `Bundle.main`.
    public var bundle: Bundle
    
    /// The name of the Property List file, usually specified with the `--custom-file-name` option.
    ///
    ///  Default value is `"package-list"`.
    public var fileName: String
    
    /// Creates a Property List package provider.
    /// - Parameters:
    ///   - bundle: The bundle to read the Property List file from.
    ///   - fileName: The name of the Property List file.
    public init(bundle: Bundle = .main, fileName: String = "package-list") {
        self.bundle = bundle
        self.fileName = fileName
    }
    
    public func packages() throws -> [Package] {
        guard let path = bundle.path(forResource: fileName, ofType: "plist") else {
            throw CocoaError(.fileNoSuchFile, userInfo: ["file_name": fileName, "file_type": "plist"])
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = PropertyListDecoder()
        return try decoder.decode([Package].self, from: data)
    }
}

extension PackageProvider where Self == PropertyListPackageProvider {
    /// A Property List package provider.
    /// - Parameters:
    ///   - bundle: The bundle to read the Property List file from.
    ///   - fileName: The name of the Property List file.
    /// - Returns: A ``PropertyListPackageProvider`` object.
    public static func propertyList(bundle: Bundle = .main, fileName: String = "package-list") -> Self {
        return PropertyListPackageProvider(bundle: bundle, fileName: fileName)
    }
}
