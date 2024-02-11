//
//  File.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 26.12.23.
//

import Foundation

protocol File {
    var url: URL { get }
    
    init(url: URL)
}
