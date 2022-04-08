//
//  SettingsBundle+Language.swift
//  SwiftPackageListCommand
//
//  Created by Felix Herrmann on 08.04.22.
//

import Foundation

extension SettingsBundle {
    
    enum Language: String, CaseIterable {
        case en, de
    }
}

extension SettingsBundle.Language {
    
    private enum RootStringsKey: String {
        case acknowledgements = "Acknowledgements"
    }
    
    private var rootStrings: [RootStringsKey: String] {
        switch self {
        case .en:
            return [
                .acknowledgements: "Acknowledgements",
            ]
        case .de:
            return [
                .acknowledgements: "Danksagungen",
            ]
        }
    }
}

extension SettingsBundle.Language {
    
    private enum AcknowledgementsStringsKey: String {
        case licenses = "Licenses"
    }
    
    private var acknowledgementsStrings: [AcknowledgementsStringsKey: String] {
        switch self {
        case .en:
            return [
                .licenses: "Licenses",
            ]
        case .de:
            return [
                .licenses: "Lizenzen",
            ]
        }
    }
}

extension SettingsBundle.Language {

    var rootFileData: Data {
        let fileString = rootStrings
            .map { "\"\($0.key.rawValue)\" = \"\($0.value)\"" }
            .joined(separator: ";\n")
            .appending(";")
        return Data(fileString.utf8)
    }
    
    var acknowledgementsFileData: Data {
        let fileString = acknowledgementsStrings
            .map { "\"\($0.key.rawValue)\" = \"\($0.value)\"" }
            .joined(separator: ";\n")
            .appending(";")
        return Data(fileString.utf8)
    }
}
