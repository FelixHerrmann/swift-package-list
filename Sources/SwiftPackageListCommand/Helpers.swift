//
//  Helpers.swift
//  SwiftPackageListCommand
//
//  Created by Felix Herrmann on 01.11.21.
//

import Foundation


// MARK: - PackageResolved.Object.Pin + checkoutURL

extension PackageResolved.Object.Pin {
    
    var checkoutURL: URL? {
        URL(string: repositoryURL.replacingOccurrences(of: ".git", with: ""))
    }
}
