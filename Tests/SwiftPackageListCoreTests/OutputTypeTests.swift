//
//  OutputTypeTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 15.05.22.
//

import XCTest
@testable import SwiftPackageListCore

final class OutputTypeTests: XCTestCase {
    func testOutputURL() {
        let jsonURL = OutputType.json.outputURL(at: "/User/test/Desktop", customFileName: nil)
        XCTAssertEqual(jsonURL.path, "/User/test/Desktop/package-list.json")
        
        let plistURL = OutputType.plist.outputURL(at: "/User/test/Desktop", customFileName: nil)
        XCTAssertEqual(plistURL.path, "/User/test/Desktop/package-list.plist")
        
        let settingsBundleURL = OutputType.settingsBundle.outputURL(at: "/User/test/Desktop", customFileName: nil)
        XCTAssertEqual(settingsBundleURL.path, "/User/test/Desktop/Settings.bundle")
        
        let pdfURL = OutputType.pdf.outputURL(at: "/User/test/Desktop", customFileName: nil)
        XCTAssertEqual(pdfURL.path, "/User/test/Desktop/Acknowledgements.pdf")
        
        let jsonCustomURL = OutputType.json.outputURL(at: "/User/test/Desktop", customFileName: "test")
        XCTAssertEqual(jsonCustomURL.path, "/User/test/Desktop/test.json")
        
        let plistCustomURL = OutputType.plist.outputURL(at: "/User/test/Desktop", customFileName: "test")
        XCTAssertEqual(plistCustomURL.path, "/User/test/Desktop/test.plist")
        
        let settingsBundleCustomURL = OutputType.settingsBundle.outputURL(at: "/User/test/Desktop", customFileName: "Test")
        XCTAssertEqual(settingsBundleCustomURL.path, "/User/test/Desktop/Test.bundle")
        
        let pdfCustomURL = OutputType.pdf.outputURL(at: "/User/test/Desktop", customFileName: "Test")
        XCTAssertEqual(pdfCustomURL.path, "/User/test/Desktop/Test.pdf")
    }
    
    func testOutputGenerator() {
        let outputURL = URL(fileURLWithPath: "")
        let project = XcodeProject(fileURL: URL(fileURLWithPath: ""), options: ProjectOptions())
        
        let jsonGenerator = OutputType.json.outputGenerator(outputURL: outputURL, packages: [], project: project)
        XCTAssertTrue(jsonGenerator is JSONGenerator)
        
        let plistGenerator = OutputType.plist.outputGenerator(outputURL: outputURL, packages: [], project: project)
        XCTAssertTrue(plistGenerator is PropertyListGenerator)
        
        let bundleGenerator = OutputType.settingsBundle.outputGenerator(outputURL: outputURL, packages: [], project: project)
        XCTAssertTrue(bundleGenerator is SettingsBundleGenerator)
        
        let pdfGenerator = OutputType.pdf.outputGenerator(outputURL: outputURL, packages: [], project: project)
        XCTAssertTrue(pdfGenerator is PDFGenerator)
    }
}
