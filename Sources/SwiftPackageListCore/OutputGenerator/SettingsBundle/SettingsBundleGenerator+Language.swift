//
//  SettingsBundleGenerator+Language.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 08.04.22.
//

import Foundation

extension SettingsBundleGenerator {
    
    enum Language: String, CaseIterable {
        case ar
        case zhHans = "zh-hans"
        case zhHant = "zh-hant"
        case en
        case fr
        case de
        case hi
        case it
        case pt
        case ru
        case es
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
        case .zhHans:
            return [
                .acknowledgements: "致谢",
            ]
        case .zhHant:
            return [
                .acknowledgements: "致謝",
            ]
        case .en:
            return [
                .acknowledgements: "Acknowledgements",
            ]
        case .fr:
            return [
                .acknowledgements: "Remerciements",
            ]
        case .de:
            return [
                .acknowledgements: "Danksagungen",
            ]
        case .hi:
            return [
                .acknowledgements: "स्वीकृतियाँ",
            ]
        case .it:
            return [
                .acknowledgements: "Ringraziamenti",
            ]
        case .pt:
            return [
                .acknowledgements: "Agradecimentos",
            ]
        case .ru:
            return [
                .acknowledgements: "Благодарности",
            ]
        case .es:
            return [
                .acknowledgements: "Expresiones de gratitud",
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
        case .zhHans:
            return [
                .licenses: "许可证",
            ]
        case .zhHant:
            return [
                .licenses: "許可證",
            ]
        case .en:
            return [
                .licenses: "Licenses",
            ]
        case .fr:
            return [
                .licenses: "Licences",
            ]
        case .de:
            return [
                .licenses: "Lizenzen",
            ]
        case .hi:
            return [
                .licenses: "लाइसेंस",
            ]
        case .it:
            return [
                .licenses: "Licenze",
            ]
        case .pt:
            return [
                .licenses: "Licenças",
            ]
        case .ru:
            return [
                .licenses: "Лицензии",
            ]
        case .es:
            return [
                .licenses: "Licencias",
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
