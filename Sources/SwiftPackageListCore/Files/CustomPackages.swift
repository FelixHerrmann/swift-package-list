//
//  CustomPackages.swift
//  SwiftPackageList
//
//  Created by Felix Herrmann on 17.02.25.
//

import Foundation
import SwiftPackageList

public struct CustomPackages: File {
    public let url: URL
    
    public init(url: URL) {
        self.url = url
    }
}

extension CustomPackages {
    public func packages() throws -> [Package] {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode([Package].self, from: data)
    }
}
