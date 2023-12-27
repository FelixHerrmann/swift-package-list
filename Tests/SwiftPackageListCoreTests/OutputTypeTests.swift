//
//  OutputTypeTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 15.05.22.
//

import XCTest
@testable import SwiftPackageListCore

final class OutputTypeTests: XCTestCase {
    func testOutputURL() throws {
        let project = XcodeProject(fileURL: URL(fileURLWithPath: ""), options: ProjectOptions())
        let options = OutputGeneratorOptions(outputURL: URL(fileURLWithPath: "/User/test/Desktop"))
        
        let anyJSONGenerator = try OutputType.json.outputGenerator(packages: [], project: project, options: options)
        let jsonGenerator = try XCTUnwrap(anyJSONGenerator as? JSONGenerator)
        XCTAssertEqual(jsonGenerator.outputURL.path, "/User/test/Desktop/package-list.json")
        
        let anyPlistGenerator = try OutputType.plist.outputGenerator(packages: [], project: project, options: options)
        let plistGenerator = try XCTUnwrap(anyPlistGenerator as? PropertyListGenerator)
        XCTAssertEqual(plistGenerator.outputURL.path, "/User/test/Desktop/package-list.plist")
        
        let anySettingsBundleGenerator = try OutputType.settingsBundle.outputGenerator(packages: [], project: project, options: options)
        let settingsBundleGenerator = try XCTUnwrap(anySettingsBundleGenerator as? SettingsBundleGenerator)
        XCTAssertEqual(settingsBundleGenerator.outputURL.path, "/User/test/Desktop/Settings.bundle")
        
        let anyPDFGenerator = try OutputType.pdf.outputGenerator(packages: [], project: project, options: options)
        let pdfGenerator = try XCTUnwrap(anyPDFGenerator as? PDFGenerator)
        XCTAssertEqual(pdfGenerator.outputURL.path, "/User/test/Desktop/Acknowledgements.pdf")
    }
    
    func testCustomOutputURL() throws {
        let project = XcodeProject(fileURL: URL(fileURLWithPath: ""), options: ProjectOptions())
        let options = OutputGeneratorOptions(outputURL: URL(fileURLWithPath: "/User/test/Desktop"), customFileName: "test")
        
        let anyJSONGenerator = try OutputType.json.outputGenerator(packages: [], project: project, options: options)
        let jsonGenerator = try XCTUnwrap(anyJSONGenerator as? JSONGenerator)
        XCTAssertEqual(jsonGenerator.outputURL.path, "/User/test/Desktop/test.json")
        
        let anyPlistGenerator = try OutputType.plist.outputGenerator(packages: [], project: project, options: options)
        let plistGenerator = try XCTUnwrap(anyPlistGenerator as? PropertyListGenerator)
        XCTAssertEqual(plistGenerator.outputURL.path, "/User/test/Desktop/test.plist")
        
        let anySettingsBundleGenerator = try OutputType.settingsBundle.outputGenerator(packages: [], project: project, options: options)
        let settingsBundleGenerator = try XCTUnwrap(anySettingsBundleGenerator as? SettingsBundleGenerator)
        XCTAssertEqual(settingsBundleGenerator.outputURL.path, "/User/test/Desktop/test.bundle")
        
        let anyPDFGenerator = try OutputType.pdf.outputGenerator(packages: [], project: project, options: options)
        let pdfGenerator = try XCTUnwrap(anyPDFGenerator as? PDFGenerator)
        XCTAssertEqual(pdfGenerator.outputURL.path, "/User/test/Desktop/test.pdf")
    }
}
