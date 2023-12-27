//
//  OutputType.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 15.03.22.
//

import Foundation
import SwiftPackageList

public enum OutputType: String, CaseIterable {
    case json
    case plist
    case settingsBundle = "settings-bundle"
    case pdf
}

extension OutputType {
    private func outputURL(
        fileName: String,
        fileExtension: String,
        options: OutputGeneratorOptions
    ) throws -> URL {
        guard let outputURL = options.outputURL else {
            throw RuntimeError("Output-path is required for output-type \(rawValue)")
        }
        
        let fileName = options.customFileName ?? fileName
        return outputURL
            .appendingPathComponent(fileName)
            .appendingPathExtension(fileExtension)
    }
    
    public func outputGenerator(
        packages: [Package],
        project: any Project,
        options: OutputGeneratorOptions = OutputGeneratorOptions()
    ) throws -> any OutputGenerator {
        switch self {
        case .json:
            let outputURL = try outputURL(fileName: "package-list", fileExtension: "json", options: options)
            return JSONGenerator(outputURL: outputURL, packages: packages)
        case .plist:
            let outputURL = try outputURL(fileName: "package-list", fileExtension: "plist", options: options)
            return PropertyListGenerator(outputURL: outputURL, packages: packages)
        case .settingsBundle:
            let outputURL = try outputURL(fileName: "Settings", fileExtension: "bundle", options: options)
            return SettingsBundleGenerator(outputURL: outputURL, packages: packages)
        case .pdf:
            let outputURL = try outputURL(fileName: "Acknowledgements", fileExtension: "pdf", options: options)
            return PDFGenerator(outputURL: outputURL, packages: packages, project: project)
        }
    }
}
