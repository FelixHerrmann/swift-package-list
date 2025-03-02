//
//  Checkouts.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 26.12.23.
//

import Foundation

struct Checkouts: Directory {
    let url: URL
}

extension Checkouts {
    func packageSource(location: String) -> PackageSource? {
        guard let checkoutURL = URL(string: location) else { return nil }
        let directoryName = checkoutURL.deletingGitExtension().lastPathComponent
        let packageSourcePath = url.appendingPathComponent(directoryName)
        return PackageSource(url: packageSourcePath)
    }
}
