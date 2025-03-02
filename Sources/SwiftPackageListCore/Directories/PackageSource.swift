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
            let files = try FileManager.default.contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: [.isRegularFileKey, .localizedNameKey],
                options: .skipsHiddenFiles
            )
            let licenseFile = files.first { file in
                let fileName = file
                    .deletingPathExtension()
                    .lastPathComponent
                    .lowercased()
                let allowedFileNames = ["license", "licence", "copying"]
                return allowedFileNames.contains(fileName)
            }
            guard let licenseFile else { return nil }
            return License(url: licenseFile)
        }
    }
}
