//
//  SettingsBundleBuilder+PropertyList.swift
//  SwiftPackageListCommand
//
//  Created by Felix Herrmann on 08.04.22.
//

import Foundation

extension SettingsBundleBuilder {
    
    enum SpecifierType: String, Encodable {
        case group = "PSGroupSpecifier"
        case childPane = "PSChildPaneSpecifier"
    }
    
    struct Specifier: Encodable {
        let `Type`: SpecifierType
        var Title: String?
        var FooterText: String?
        var File: String?
    }
    
    struct PropertyList: Encodable {
        var StringsTable: String?
        let PreferenceSpecifiers: [Specifier]
    }
}

extension SettingsBundleBuilder.Specifier {
    
    static func group(title: String? = nil, footerText: String? = nil) -> SettingsBundleBuilder.Specifier {
        return SettingsBundleBuilder.Specifier(Type: .group, Title: title, FooterText: footerText)
    }
    
    static func childPane(title: String, file: String) -> SettingsBundleBuilder.Specifier {
        return SettingsBundleBuilder.Specifier(Type: .childPane, Title: title, File: file)
    }
}
