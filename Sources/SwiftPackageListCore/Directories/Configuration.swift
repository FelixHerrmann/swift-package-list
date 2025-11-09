//
//  Configuration.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 09.11.25.
//

import Foundation

struct Configuration: Directory {
    let url: URL
}

extension Configuration {
    var mirrors: Mirrors? {
        get throws {
            let url = url.appendingPathComponent("mirrors.json")
            guard FileManager.default.fileExists(atPath: url.path) else { return nil }
            return try Mirrors(url: url)
        }
    }
}
