//
//  JSONGenerator.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 15.05.22.
//

import Foundation
import SwiftPackageList

struct JSONGenerator: OutputGenerator {
    let outputURL: URL
    let packages: [Package]
    
    private let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }()
    
    func generateOutput() throws {
        let jsonData = try jsonEncoder.encode(packages)
        try jsonData.write(to: outputURL)
        
        print("Generated \(outputURL.path)")
    }
}
