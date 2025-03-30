//
//  SwiftPackageListPlugin.Error.swift
//  SwiftPackageListPlugin
//
//  Created by Felix Herrmann on 03.02.24.
//

import PackagePlugin

extension SwiftPackageListPlugin {
    enum Error: Swift.Error {
        case configurationUnavailable(path: Path, underlyingError: Swift.Error)
        case configurationInvalid(path: Path, underlyingError: Swift.Error)
        case sourcePackagesNotFound(pluginWorkDirectory: Path)
    }
}

extension SwiftPackageListPlugin.Error: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .configurationUnavailable(path: let path, underlyingError: let error):
            return "The configuration at \(path.string) is unavailable: \(error)"
        case .configurationInvalid(path: let path, underlyingError: let error):
            return "The configuration at \(path.string) has an invalid format: \(error)"
        case .sourcePackagesNotFound(pluginWorkDirectory: let directory):
            return "SourcePackages directory not found from \(directory.string)"
        }
    }
}
