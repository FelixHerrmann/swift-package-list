//
//  VersionedFileStorage.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 26.12.23.
//

import Foundation

protocol VersionedFileStorage {
    init(url: URL) throws
}
