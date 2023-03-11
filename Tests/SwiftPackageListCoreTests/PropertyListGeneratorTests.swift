//
//  PropertyListGeneratorTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 16.05.22.
//

import XCTest
import SwiftPackageList
@testable import SwiftPackageListCore

final class PropertyListGeneratorTests: XCTestCase {
    
    private let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("package-list.plist")
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let url = try XCTUnwrap(Bundle.module.url(forResource: "Project", withExtension: "xcodeproj", subdirectory: "Resources"))
        let project = try XCTUnwrap(Project(path: url.path))
        let package = Package(
            name: "test",
            version: "1.0.0",
            branch: nil,
            revision: "xxxx",
            repositoryURL: URL(string: "https://github.com/test/test")!, // swiftlint:disable:this force_unwrapping
            license: "MIT"
        )
        
        let propertyListGenerator = PropertyListGenerator(outputURL: outputURL, packages: [package], project: project)
        try propertyListGenerator.generateOutput()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        try FileManager.default.removeItem(at: outputURL)
    }
    
    func testOutput() throws {
        let output = try String(contentsOf: outputURL)
        // swiftlint:disable indentation_width
        let expectedOutput = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <array>
        	<dict>
        		<key>license</key>
        		<string>MIT</string>
        		<key>name</key>
        		<string>test</string>
        		<key>repositoryURL</key>
        		<dict>
        			<key>relative</key>
        			<string>https://github.com/test/test</string>
        		</dict>
        		<key>revision</key>
        		<string>xxxx</string>
        		<key>version</key>
        		<string>1.0.0</string>
        	</dict>
        </array>
        </plist>
        
        """
        // tabs and line breaks are important here
        // swiftlint:enable indentation_width
        XCTAssertEqual(output, expectedOutput)
    }
}
