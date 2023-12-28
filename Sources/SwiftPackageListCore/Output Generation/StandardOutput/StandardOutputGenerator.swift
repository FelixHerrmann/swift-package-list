//
//  StandardOutputGenerator.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 27.12.23.
//

import Foundation
import SwiftPackageList

struct StandardOutputGenerator: OutputGenerator {
    let packages: [Package]
    
    private let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }()
    
    func generateOutput() throws {
        let jsonData = try jsonEncoder.encode(packages)
        let jsonString = String(decoding: jsonData, as: UTF8.self)
        print(jsonString)
    }
}
