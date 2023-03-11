//
//  SettingsBundleGenerator+PropertyList.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 08.04.22.
//

import Foundation

extension SettingsBundleGenerator {
    enum SpecifierType: String, Encodable {
        case group = "PSGroupSpecifier"
        case childPane = "PSChildPaneSpecifier"
    }
    
    struct Specifier: Encodable {
        let type: SpecifierType
        var title: String?
        var footerText: String?
        var file: String?
        
        enum CodingKeys: String, CodingKey {
            case type = "Type"
            case title = "Title"
            case footerText = "FooterText"
            case file = "File"
        }
    }
    
    struct PropertyList: Encodable {
        var stringsTable: String?
        let preferenceSpecifiers: [Specifier]
        
        enum CodingKeys: String, CodingKey {
            case stringsTable = "StringsTable"
            case preferenceSpecifiers = "PreferenceSpecifiers"
        }
    }
}

extension SettingsBundleGenerator.Specifier {
    static func group(title: String? = nil, footerText: String? = nil) -> SettingsBundleGenerator.Specifier {
        return SettingsBundleGenerator.Specifier(type: .group, title: title, footerText: footerText)
    }
    
    static func childPane(title: String, file: String) -> SettingsBundleGenerator.Specifier {
        return SettingsBundleGenerator.Specifier(type: .childPane, title: title, file: file)
    }
}
