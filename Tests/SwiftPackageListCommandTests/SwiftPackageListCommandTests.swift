//
//  SwiftPackageListCommandTests.swift
//  SwiftPackageListCommandTests
//
//  Created by Felix Herrmann on 18.05.22.
//

import XCTest

class SwiftPackageListCommandTests: XCTestCase {
    
    private var productsDirectory: URL {
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
    }
    
    func testCommandExecution() throws {
        let swiftPackageListBinary = productsDirectory.appendingPathComponent("swift-package-list")
        
        let process = Process()
        process.executableURL = swiftPackageListBinary
        process.arguments = ["--version"]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        try process.run()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(decoding: data, as: UTF8.self).trimmingCharacters(in: .whitespacesAndNewlines)
        
        let versionNumbers = output.split(separator: ".")
        let majorVersionNumber = versionNumbers[0]
        let minorVersionNumber = versionNumbers[1]
        let patchVersionNumber = versionNumbers[2]
        XCTAssertNotNil(Int(majorVersionNumber))
        XCTAssertNotNil(Int(minorVersionNumber))
        XCTAssertNotNil(Int(patchVersionNumber))
    }
}
