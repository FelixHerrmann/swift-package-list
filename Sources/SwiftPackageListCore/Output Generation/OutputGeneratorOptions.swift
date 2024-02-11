//
//  OutputGeneratorOptions.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 27.12.23.
//

import Foundation

public struct OutputGeneratorOptions {
    public var outputURL: URL?
    public var customFileName: String?
    
    public init(outputURL: URL? = nil, customFileName: String? = nil) {
        self.outputURL = outputURL
        self.customFileName = customFileName
    }
}
