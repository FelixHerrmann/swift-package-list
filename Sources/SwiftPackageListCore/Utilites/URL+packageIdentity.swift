//
//  URL+packageIdentity.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 14.02.24.
//

import Foundation

extension URL {
    var packageIdentity: String {
        // We cannot use .deletingPathExtension() here because repository names may contain dots.
        if lastPathComponent.hasSuffix(".git") {
            return String(lastPathComponent.dropLast(4))
        }
        return lastPathComponent
    }
}
