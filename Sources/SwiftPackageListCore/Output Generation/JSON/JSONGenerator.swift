//
//  JSONGenerator.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 15.05.22.
//

import Foundation
import SwiftPackageList

struct JSONGenerator: OutputGenerator {
    private let outputURL: URL
    private let packages: [Package]
    
    private let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }()
    
    init(outputURL: URL, packages: [Package], project: any Project) {
        self.outputURL = outputURL
        self.packages = packages
    }
    
    func generateOutput() throws {
        let jsonData = try jsonEncoder.encode(packages)
        try jsonData.write(to: outputURL)
        
        print("Generated \(outputURL)")
    }
}
