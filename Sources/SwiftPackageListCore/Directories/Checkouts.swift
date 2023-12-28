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
    func license(checkoutURL: URL) throws -> String? {
        let checkoutName = checkoutURL.deletingPathExtension().lastPathComponent
        let checkoutPath = url.appendingPathComponent(checkoutName)
        let packageFiles = try FileManager.default.contentsOfDirectory(
            at: checkoutPath,
            includingPropertiesForKeys: [.isRegularFileKey, .localizedNameKey],
            options: .skipsHiddenFiles
        )
        let licenseFileURL = packageFiles.first { packageFile in
            let fileName = packageFile.deletingPathExtension().lastPathComponent.lowercased()
            let allowedFileNames = ["license", "licence"]
            return allowedFileNames.contains(fileName)
        }
        guard let licenseFileURL else { return nil }
        return try String(contentsOf: licenseFileURL, encoding: .utf8)
    }
}
