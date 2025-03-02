//
//  License.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 02.03.25.
//

import Foundation

struct License: File {
    let url: URL
}

extension License {
    static let allowedFileNames = [
        "license",
        "licence",
        "copying",
    ]
    
    init?(uncheckedURL url: URL) {
        let fileName = url
            .deletingPathExtension()
            .lastPathComponent
            .lowercased()
        guard Self.allowedFileNames.contains(fileName) else { return nil }
        self.init(url: url)
    }
}

extension License {
    var content: String {
        get throws {
            return try String(contentsOf: url, encoding: .utf8)
        }
    }
}
