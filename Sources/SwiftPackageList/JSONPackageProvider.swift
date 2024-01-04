//
//  JSONPackageProvider.swift
//  SwiftPackageList
//
//  Created by Felix Herrmann on 02.01.24.
//

import Foundation

/// A package provider for `.json` package-lists stored in a `Bundle`.
public struct JSONPackageProvider: PackageProvider {
    
    /// The bundle to read the JSON file from.
    ///
    /// Default value is `Bundle.main`.
    public var bundle: Bundle
    
    /// The name of the JSON file, usually specified with the `--custom-file-name` option.
    ///
    ///  Default value is `"package-list"`.
    public var fileName: String
    
    /// Creates a JSON package provider.
    /// - Parameters:
    ///   - bundle: The bundle to read the JSON file from.
    ///   - fileName: The name of the JSON file.
    public init(bundle: Bundle = .main, fileName: String = "package-list") {
        self.bundle = bundle
        self.fileName = fileName
    }
    
    public func packages() throws -> [Package] {
        guard let path = bundle.path(forResource: fileName, ofType: "json") else {
            throw CocoaError(.fileNoSuchFile, userInfo: ["file_name": fileName, "file_type": "json"])
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        return try decoder.decode([Package].self, from: data)
    }
}

extension PackageProvider where Self == JSONPackageProvider {
    /// A JSON package provider.
    /// - Parameters:
    ///   - bundle: The bundle to read the JSON file from.
    ///   - fileName: The name of the JSON file.
    /// - Returns: A ``JSONPackageProvider`` object.
    public static func json(bundle: Bundle = .main, fileName: String = "package-list") -> Self {
        return JSONPackageProvider(bundle: bundle, fileName: fileName)
    }
}
