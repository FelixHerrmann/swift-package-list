//
//  SettingsBundleBuilder.swift
//  SwiftPackageListCommand
//
//  Created by Felix Herrmann on 07.04.22.
//

import Foundation
import SwiftPackageList

struct SettingsBundleBuilder {
    
    private let url: URL
    private let packagesURL: URL
    private let packages: [Package]
    
    private let fileManager: FileManager = .default
    private let encoder: PropertyListEncoder = {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        return encoder
    }()
    
    init(outputURL: URL, packages: [Package]) {
        self.url = outputURL.appendingPathComponent("Settings.bundle")
        self.packagesURL = url.appendingPathComponent("Packages")
        self.packages = packages
    }
    
    func build() throws {
        try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
        try createRootPlist()
        try createAcknowledgementsPlist()
        
        try fileManager.createDirectory(at: packagesURL, withIntermediateDirectories: true)
        for package in packages {
            try createPackagePlist(for: package)
        }
        
        for language in Language.allCases {
            try createStringsFile(for: language)
        }
    }
    
    private func createRootPlist() throws {
        let rootURL = url.appendingPathComponent("Root.plist")
        guard !fileManager.fileExists(atPath: rootURL.path) else { return }
        let rootSpecifiers: [Specifier] = [.childPane(title: "Acknowledgements", file: "Acknowledgements")]
        let rootPlist = PropertyList(StringsTable: "Root", PreferenceSpecifiers: rootSpecifiers)
        let encodedRoot = try encoder.encode(rootPlist)
        try encodedRoot.write(to: rootURL)
    }
    
    private func createAcknowledgementsPlist() throws {
        let packageChildPanges: [Specifier] = packages.map { .childPane(title: $0.name, file: "Packages/\($0.name)") }
        let acknowledgementsSpecifiers: [Specifier] = [.group(title: "Licenses")] + packageChildPanges
        let acknowledgementsPlist = PropertyList(StringsTable: "Acknowledgements", PreferenceSpecifiers: acknowledgementsSpecifiers)
        let encodedAcknowledgements = try encoder.encode(acknowledgementsPlist)
        let acknowledgementsURL = url.appendingPathComponent("Acknowledgements.plist")
        try encodedAcknowledgements.write(to: acknowledgementsURL)
    }
    
    private func createPackagePlist(for package: Package) throws {
        let packageSpecifiers: [Specifier] = [.group(footerText: package.license)]
        let packagePlist = PropertyList(PreferenceSpecifiers: packageSpecifiers)
        let encodedPackage = try encoder.encode(packagePlist)
        let packageURL = packagesURL.appendingPathComponent("\(package.name).plist")
        try encodedPackage.write(to: packageURL)
    }
    
    private func createStringsFile(for language: Language) throws {
        let languageURL = url.appendingPathComponent("\(language.rawValue).lproj")
        try fileManager.createDirectory(at: languageURL, withIntermediateDirectories: true)
        
        let rootStringsURL = languageURL.appendingPathComponent("Root.strings")
        if !fileManager.fileExists(atPath: rootStringsURL.path) {
            try language.rootFileData.write(to: rootStringsURL)
        }
        
        let acknowledgementsStringsURL = languageURL.appendingPathComponent("Acknowledgements.strings")
        try language.acknowledgementsFileData.write(to: acknowledgementsStringsURL)
    }
}
