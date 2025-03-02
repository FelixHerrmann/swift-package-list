//
//  SettingsBundleGeneratorTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 16.05.22.
//

import XCTest
import SwiftPackageList
@testable import SwiftPackageListCore

final class SettingsBundleGeneratorTests: XCTestCase {
    
    private let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("Settings.bundle")
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let package = Package(
            kind: .remoteSourceControl,
            identity: "test",
            name: "test",
            version: "1.0.0",
            branch: nil,
            revision: "xxxx",
            location: "https://github.com/test/test",
            license: "MIT"
        )
        
        let settingsBundleGenerator = SettingsBundleGenerator(outputURL: outputURL, packages: [package])
        try settingsBundleGenerator.generateOutput()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        try FileManager.default.removeItem(at: outputURL)
    }
    
    func testRootPlistOutput() throws {
        let rootPlist = try String(contentsOf: outputURL.appendingPathComponent("Root.plist"))
        // swiftlint:disable indentation_width
        let expectedRootPlist = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
        	<key>PreferenceSpecifiers</key>
        	<array>
        		<dict>
        			<key>File</key>
        			<string>Acknowledgements</string>
        			<key>Title</key>
        			<string>Acknowledgements</string>
        			<key>Type</key>
        			<string>PSChildPaneSpecifier</string>
        		</dict>
        	</array>
        	<key>StringsTable</key>
        	<string>Root</string>
        </dict>
        </plist>
        
        """
        // swiftlint:enable indentation_width
        XCTAssertEqual(rootPlist, expectedRootPlist)
    }
    
    func testAcknowledgementsPlistOutput() throws {
        let acknowledgementsPlist = try String(contentsOf: outputURL.appendingPathComponent("Acknowledgements.plist"))
        // swiftlint:disable indentation_width
        let expectedAcknowledgementsPlist = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
        	<key>PreferenceSpecifiers</key>
        	<array>
        		<dict>
        			<key>Title</key>
        			<string>Licenses</string>
        			<key>Type</key>
        			<string>PSGroupSpecifier</string>
        		</dict>
        		<dict>
        			<key>File</key>
        			<string>Packages/test</string>
        			<key>Title</key>
        			<string>test</string>
        			<key>Type</key>
        			<string>PSChildPaneSpecifier</string>
        		</dict>
        	</array>
        	<key>StringsTable</key>
        	<string>Acknowledgements</string>
        </dict>
        </plist>
        
        """
        // swiftlint:enable indentation_width
        XCTAssertEqual(acknowledgementsPlist, expectedAcknowledgementsPlist)
    }
    
    func testTestPlistPathOutput() throws {
        let testPlistPath = outputURL.appendingPathComponent("Packages").appendingPathComponent("test.plist")
        let testPlist = try String(contentsOf: testPlistPath)
        // swiftlint:disable indentation_width
        let expectedTestPlist = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
        	<key>PreferenceSpecifiers</key>
        	<array>
        		<dict>
        			<key>FooterText</key>
        			<string>MIT</string>
        			<key>Type</key>
        			<string>PSGroupSpecifier</string>
        		</dict>
        	</array>
        </dict>
        </plist>
        
        """
        // swiftlint:enable indentation_width
        XCTAssertEqual(testPlist, expectedTestPlist)
    }
    
    func testRootStringsOutput() throws {
        let rootStringsPath = outputURL.appendingPathComponent("de.lproj").appendingPathComponent("Root.strings")
        let rootStrings = try String(contentsOf: rootStringsPath)
        let expectedRootStrings = """
        "Acknowledgements" = "Danksagungen";
        """
        XCTAssertEqual(rootStrings, expectedRootStrings)
    }
    
    func testAcknowledgementsStringsOutput() throws {
        let acknowledgementsStringsPath = outputURL
            .appendingPathComponent("de.lproj")
            .appendingPathComponent("Acknowledgements.strings")
        let acknowledgementsStrings = try String(contentsOf: acknowledgementsStringsPath)
        let expectedAcknowledgementsStrings = """
        "Licenses" = "Lizenzen";
        """
        XCTAssertEqual(acknowledgementsStrings, expectedAcknowledgementsStrings)
    }
}
