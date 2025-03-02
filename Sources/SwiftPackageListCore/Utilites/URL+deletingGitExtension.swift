//
//  URL+deletingGitExtension.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 14.02.24.
//

import Foundation

extension URL {
    func deletingGitExtension() -> URL {
        guard pathExtension == "git" else { return self }
        return deletingPathExtension()
    }
}
