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
    var content: String {
        get throws {
            return try String(contentsOf: url, encoding: .utf8)
        }
    }
}
