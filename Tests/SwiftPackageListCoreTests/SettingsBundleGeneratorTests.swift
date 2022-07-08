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
    
    let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("Settings").appendingPathExtension("bundle")
    
    override func setUpWithError() throws {
        let url = try XCTUnwrap(Bundle.module.url(forResource: "Project", withExtension: "xcodeproj", subdirectory: "Resources"))
        let project = try XCTUnwrap(Project(path: url.path))
        let package = Package(name: "test", version: "1.0.0", branch: nil, revision: "xxxx", repositoryURL: URL(string: "https://github.com/test/test")!, license: "MIT")
        
        let settingsBundleGenerator = SettingsBundleGenerator(outputURL: outputURL, packages: [package], project: project)
        try settingsBundleGenerator.generateOutput()
    }
    
    override func tearDownWithError() throws {
        try FileManager.default.removeItem(at: outputURL)
    }
    
    func testOutput() throws {
        let rootPlist = try String(contentsOf: outputURL.appendingPathComponent("Root.plist"))
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
        XCTAssertEqual(rootPlist, expectedRootPlist)
        
        let acknowledgementsPlist = try String(contentsOf: outputURL.appendingPathComponent("Acknowledgements.plist"))
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
        XCTAssertEqual(acknowledgementsPlist, expectedAcknowledgementsPlist)
        
        let testPlist = try String(contentsOf: outputURL.appendingPathComponent("Packages").appendingPathComponent("test.plist"))
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
        XCTAssertEqual(testPlist, expectedTestPlist)
        
        let rootStrings = try String(contentsOf: outputURL.appendingPathComponent("de.lproj").appendingPathComponent("Root.strings"))
        let expectedRootStrings = """
        "Acknowledgements" = "Danksagungen";
        """
        XCTAssertEqual(rootStrings, expectedRootStrings)
        
        let acknowledgementsStrings = try String(contentsOf: outputURL.appendingPathComponent("de.lproj").appendingPathComponent("Acknowledgements.strings"))
        let expectedAcknowledgementsStrings = """
        "Licenses" = "Lizenzen";
        """
        XCTAssertEqual(acknowledgementsStrings, expectedAcknowledgementsStrings)
    }
}
