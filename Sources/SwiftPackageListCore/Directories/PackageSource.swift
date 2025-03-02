//
//  PackageSource.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 02.03.25.
//

import Foundation

struct PackageSource: Directory {
    let url: URL
}

extension PackageSource {
    var license: License? {
        get throws {
            return try FileManager.default
                .contentsOfDirectory(
                    at: url,
                    includingPropertiesForKeys: [.isRegularFileKey, .localizedNameKey],
                    options: .skipsHiddenFiles
                )
                .compactMap(License.init(uncheckedURL:))
                .first
        }
    }
}
