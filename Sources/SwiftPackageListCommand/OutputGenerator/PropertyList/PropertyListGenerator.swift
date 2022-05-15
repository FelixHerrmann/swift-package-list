//
//  PropertyListGenerator.swift
//  SwiftPackageListCommand
//
//  Created by Felix Herrmann on 15.05.22.
//

import Foundation
import SwiftPackageList

struct PropertyListGenerator: OutputGenerator {
    
    private let outputURL: URL
    private let packages: [Package]
    
    private let propertyListEncoder: PropertyListEncoder = {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        return encoder
    }()
    
    init(outputURL: URL, packages: [Package], project: Project) {
        self.outputURL = outputURL
        self.packages = packages
    }
    
    func generateOutput() throws {
        let propertyListData = try propertyListEncoder.encode(packages)
        try propertyListData.write(to: outputURL)
    }
}
