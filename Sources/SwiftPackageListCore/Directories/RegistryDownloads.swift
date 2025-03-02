//
//  RegistryDownloads.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 01.03.25.
//

import Foundation

struct RegistryDownloads: Directory {
    let url: URL
}

extension RegistryDownloads {
    func packageSource(identity: String, version: String?) -> PackageSource? {
        guard let version else { return nil }
        guard let registryIdentity = RegistryIdentity(identity: identity) else { return nil }
        let packageSourcePath = url
            .appendingPathComponent(registryIdentity.scope)
            .appendingPathComponent(registryIdentity.name)
            .appendingPathComponent(version)
        return PackageSource(url: packageSourcePath)
    }
}
