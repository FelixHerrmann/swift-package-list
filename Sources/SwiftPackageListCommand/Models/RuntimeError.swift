//
//  RuntimeError.swift
//  SwiftPackageListCommand
//
//  Created by Felix Herrmann on 15.03.22.
//

import Foundation

struct RuntimeError: Error, CustomStringConvertible {
    let description: String
    
    init(_ description: String) {
        self.description = description
    }
}
