//
//  SettingsBundleGenerator+Language.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 08.04.22.
//

import Foundation

extension SettingsBundleGenerator {
    enum Language: String, CaseIterable {
        // swiftlint:disable identifier_name
        case ar
        case de
        case en
        case es
        case fr
        case hi
        case it
        case pl
        case pt
        case ru
        case tr
        case uk
        case zhHans = "zh-hans"
        case zhHant = "zh-hant"
        // swiftlint:enable identifier_name
    }
}

extension SettingsBundleGenerator.Language {
    private enum RootStringsKey: String {
        case acknowledgements = "Acknowledgements"
    }
    
    private var rootStrings: [RootStringsKey: String] {
        switch self {
        case .ar:
            return [
                .acknowledgements: "مخزن",
            ]
        case .de:
            return [
                .acknowledgements: "Danksagungen",
            ]
        case .en:
            return [
                .acknowledgements: "Acknowledgements",
            ]
        case .es:
            return [
                .acknowledgements: "Expresiones de gratitud",
            ]
        case .fr:
            return [
                .acknowledgements: "Remerciements",
            ]
        case .hi:
            return [
                .acknowledgements: "स्वीकृतियाँ",
            ]
        case .it:
            return [
                .acknowledgements: "Ringraziamenti",
            ]
        case .pl:
            return [
                .acknowledgements: "Podziękowania",
            ]
        case .pt:
            return [
                .acknowledgements: "Agradecimentos",
            ]
        case .ru:
            return [
                .acknowledgements: "Благодарности",
            ]
        case .tr:
            return [
                .acknowledgements: "Teşekkürler",
            ]
        case .uk:
            return [
                .acknowledgements: "Подяки",
            ]
        case .zhHans:
            return [
                .acknowledgements: "致谢",
            ]
        case .zhHant:
            return [
                .acknowledgements: "致謝",
            ]
        }
    }
}

extension SettingsBundleGenerator.Language {
    private enum AcknowledgementsStringsKey: String {
        case licenses = "Licenses"
    }
    
    private var acknowledgementsStrings: [AcknowledgementsStringsKey: String] {
        switch self {
        case .ar:
            return [
                .licenses: "التراخيص",
            ]
        case .de:
            return [
                .licenses: "Lizenzen",
            ]
        case .en:
            return [
                .licenses: "Licenses",
            ]
        case .es:
            return [
                .licenses: "Licencias",
            ]
        case .fr:
            return [
                .licenses: "Licences",
            ]
        case .hi:
            return [
                .licenses: "लाइसेंस",
            ]
        case .it:
            return [
                .licenses: "Licenze",
            ]
        case .pl:
            return [
                .licenses: "Licencje",
            ]
        case .pt:
            return [
                .licenses: "Licenças",
            ]
        case .ru:
            return [
                .licenses: "Лицензии",
            ]
        case .tr:
            return [
                .licenses: "Lisanslar",
            ]
        case .uk:
            return [
                .licenses: "Ліцензії",
            ]
        case .zhHans:
            return [
                .licenses: "许可证",
            ]
        case .zhHant:
            return [
                .licenses: "許可證",
            ]
        }
    }
}

extension SettingsBundleGenerator.Language {
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
