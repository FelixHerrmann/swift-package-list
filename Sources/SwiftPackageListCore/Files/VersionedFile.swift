//
//  VersionedFile.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 26.12.23.
//

import Foundation

protocol VersionedFile {
    associatedtype Storage = VersionedFileStorage
    
    var url: URL { get }
    var storage: Storage { get }
    
    init(url: URL) throws
}
