//
//  PropertyListGenerator.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 15.05.22.
//

import Foundation
import SwiftPackageList

struct PropertyListGenerator: OutputGenerator {
    let outputURL: URL
    let packages: [Package]
    
    private let propertyListEncoder: PropertyListEncoder = {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        return encoder
    }()
    
    func generateOutput() throws {
        let propertyListData = try propertyListEncoder.encode(packages)
        try propertyListData.write(to: outputURL)
        
        print("Generated \(outputURL)")
    }
}
