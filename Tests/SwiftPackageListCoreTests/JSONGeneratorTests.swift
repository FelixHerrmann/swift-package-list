//
//  JSONGeneratorTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 16.05.22.
//

import XCTest
import SwiftPackageList
@testable import SwiftPackageListCore

final class JSONGeneratorTests: XCTestCase {
    
    private let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("package-list.json")
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let package = Package(
            identity: "test",
            name: "test",
            version: "1.0.0",
            branch: nil,
            revision: "xxxx",
            repositoryURL: URL(string: "https://github.com/test/test")!, // swiftlint:disable:this force_unwrapping
            license: "MIT"
        )
        
        let jsonGenerator = JSONGenerator(outputURL: outputURL, packages: [package])
        try jsonGenerator.generateOutput()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        try FileManager.default.removeItem(at: outputURL)
    }
    
    func testOutput() throws {
        let output = try String(contentsOf: outputURL)
        // swiftlint:disable indentation_width
        let expectedOutput = """
        [
          {
            "identity" : "test",
            "license" : "MIT",
            "location" : "https:\\/\\/github.com\\/test\\/test",
            "name" : "test",
            "revision" : "xxxx",
            "version" : "1.0.0"
          }
        ]
        """
        // swiftlint:enable indentation_width
        XCTAssertEqual(output, expectedOutput)
    }
}
