//
//  JSONGeneratorTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 16.05.22.
//

import XCTest
import SwiftPackageList
@testable import SwiftPackageListCore

class JSONGeneratorTests: XCTestCase {
    
    let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("package-list").appendingPathExtension("json")
    
    override func setUpWithError() throws {
        let url = try XCTUnwrap(Bundle.module.url(forResource: "Project", withExtension: "xcodeproj", subdirectory: "Resources"))
        let project = try XCTUnwrap(Project(path: url.path))
        let package = Package(name: "test", version: "1.0.0", branch: nil, revision: "xxxx", repositoryURL: URL(string: "https://github.com/test/test")!, license: "MIT")
        
        let jsonGenerator = JSONGenerator(outputURL: outputURL, packages: [package], project: project)
        try jsonGenerator.generateOutput()
    }
    
    override func tearDownWithError() throws {
        try FileManager.default.removeItem(at: outputURL)
    }
    
    func testOutput() throws {
        let output = try String(contentsOf: outputURL)
        let expectedOutput = """
        [
          {
            "revision" : "xxxx",
            "license" : "MIT",
            "name" : "test",
            "repositoryURL" : "https:\\/\\/github.com\\/test\\/test",
            "version" : "1.0.0"
          }
        ]
        """
        XCTAssertEqual(output, expectedOutput)
    }
}
