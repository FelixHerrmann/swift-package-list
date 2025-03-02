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
    func license(location: String) throws -> String? {
        guard let checkoutURL = URL(string: location) else { return nil }
        let checkoutName = checkoutURL.deletingGitExtension().lastPathComponent
        let checkoutPath = url.appendingPathComponent(checkoutName)
        let packageFiles = try FileManager.default.contentsOfDirectory(
            at: checkoutPath,
            includingPropertiesForKeys: [.isRegularFileKey, .localizedNameKey],
            options: .skipsHiddenFiles
        )
        let licenseFileURL = packageFiles.first { packageFile in
            let fileName = packageFile.deletingPathExtension().lastPathComponent.lowercased()
            let allowedFileNames = ["license", "licence", "copying"]
            return allowedFileNames.contains(fileName)
        }
        guard let licenseFileURL else { return nil }
        return try String(contentsOf: licenseFileURL, encoding: .utf8)
    }
}
