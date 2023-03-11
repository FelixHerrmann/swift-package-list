//
//  FileTypeTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 15.05.22.
//

import XCTest
@testable import SwiftPackageListCore

final class FileTypeTests: XCTestCase {
    
    func testOutputURL() {
        let jsonURL = FileType.json.outputURL(at: "/User/test/Desktop", customFileName: nil)
        XCTAssertEqual(jsonURL.path, "/User/test/Desktop/package-list.json")
        
        let plistURL = FileType.plist.outputURL(at: "/User/test/Desktop", customFileName: nil)
        XCTAssertEqual(plistURL.path, "/User/test/Desktop/package-list.plist")
        
        let settingsBundleURL = FileType.settingsBundle.outputURL(at: "/User/test/Desktop", customFileName: nil)
        XCTAssertEqual(settingsBundleURL.path, "/User/test/Desktop/Settings.bundle")
        
        let pdfURL = FileType.pdf.outputURL(at: "/User/test/Desktop", customFileName: nil)
        XCTAssertEqual(pdfURL.path, "/User/test/Desktop/Acknowledgements.pdf")
        
        let jsonCustomURL = FileType.json.outputURL(at: "/User/test/Desktop", customFileName: "test")
        XCTAssertEqual(jsonCustomURL.path, "/User/test/Desktop/test.json")
        
        let plistCustomURL = FileType.plist.outputURL(at: "/User/test/Desktop", customFileName: "test")
        XCTAssertEqual(plistCustomURL.path, "/User/test/Desktop/test.plist")
        
        let settingsBundleCustomURL = FileType.settingsBundle.outputURL(at: "/User/test/Desktop", customFileName: "Test")
        XCTAssertEqual(settingsBundleCustomURL.path, "/User/test/Desktop/Test.bundle")
        
        let pdfCustomURL = FileType.pdf.outputURL(at: "/User/test/Desktop", customFileName: "Test")
        XCTAssertEqual(pdfCustomURL.path, "/User/test/Desktop/Test.pdf")
    }
    
    func testOutputGenerator() {
        let outputURL = URL(fileURLWithPath: "")
        let project: Project = .xcodeproj(fileURL: URL(fileURLWithPath: ""))
        
        let jsonGenerator = FileType.json.outputGenerator(outputURL: outputURL, packages: [], project: project)
        XCTAssertTrue(jsonGenerator is JSONGenerator)
        
        let plistGenerator = FileType.plist.outputGenerator(outputURL: outputURL, packages: [], project: project)
        XCTAssertTrue(plistGenerator is PropertyListGenerator)
        
        let bundleGenerator = FileType.settingsBundle.outputGenerator(outputURL: outputURL, packages: [], project: project)
        XCTAssertTrue(bundleGenerator is SettingsBundleGenerator)
        
        let pdfGenerator = FileType.pdf.outputGenerator(outputURL: outputURL, packages: [], project: project)
        XCTAssertTrue(pdfGenerator is PDFGenerator)
    }
}
