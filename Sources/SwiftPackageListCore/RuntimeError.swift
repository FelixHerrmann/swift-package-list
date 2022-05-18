//
//  RuntimeError.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 15.03.22.
//

import Foundation

public struct RuntimeError: Error, CustomStringConvertible {
    
    public let description: String
    
    public init(_ description: String) {
        self.description = description
    }
}
