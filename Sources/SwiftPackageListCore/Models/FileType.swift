//
//  FileType.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 15.03.22.
//

import Foundation
import ArgumentParser
import SwiftPackageList

public enum FileType: String, CaseIterable, ExpressibleByArgument {
    case json
    case plist
    case settingsBundle = "settings-bundle"
    case pdf
}

extension FileType {
    
    private var fileExtension: String {
        switch self {
        case .json: return "json"
        case .plist: return "plist"
        case .settingsBundle: return "bundle"
        case .pdf: return "pdf"
        }
    }
    
    private var defaultFileName: String {
        switch self {
        case .json: return "package-list"
        case .plist: return "package-list"
        case .settingsBundle: return "Settings"
        case .pdf: return "Acknowledgements"
        }
    }
}

extension FileType {
    
    public func outputURL(at outputPath: String, customFileName: String?) -> URL {
        let fileName = customFileName ?? defaultFileName
        return URL(fileURLWithPath: outputPath)
            .appendingPathComponent(fileName)
            .appendingPathExtension(fileExtension)
    }
    
    public func outputGenerator(outputURL: URL, packages: [Package], project: Project) -> any OutputGenerator {
        switch self {
        case .json: return JSONGenerator(outputURL: outputURL, packages: packages, project: project)
        case .plist: return PropertyListGenerator(outputURL: outputURL, packages: packages, project: project)
        case .settingsBundle: return SettingsBundleGenerator(outputURL: outputURL, packages: packages, project: project)
        case .pdf: return PDFGenerator(outputURL: outputURL, packages: packages, project: project)
        }
    }
}
