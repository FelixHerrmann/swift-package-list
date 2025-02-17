//
//  JSONPackageProviderTests.swift
//  SwiftPackageListTests
//
//  Created by Felix Herrmann on 02.01.24.
//

import XCTest
@testable import SwiftPackageList

final class JSONPackageProviderTests: XCTestCase {
    func testOutput() throws {
        let packageProvider = JSONPackageProvider(bundle: .module, fileName: "example_1")
        let packages = try packageProvider.packages()
        
        let expectedIdentities = ["swift-algorithms", "swift-argument-parser", "swift-collections", "swift-numerics"]
        XCTAssertEqual(packages.map(\.identity), expectedIdentities)
        
        let expectedNames = ["swift-algorithms", "swift-argument-parser", "swift-collections", "swift-numerics"]
        XCTAssertEqual(packages.map(\.name), expectedNames)
        
        let expectedVersions = ["1.0.0", nil, nil, "1.0.2"]
        XCTAssertEqual(packages.map(\.version), expectedVersions)
        
        let expectedBranches = [nil, nil, "main", nil]
        XCTAssertEqual(packages.map(\.branch), expectedBranches)
        
        let expectedRevisions = [
            "b14b7f4c528c942f121c8b860b9410b2bf57825e",
            "060d52364cf2a3e06b7adf0b17dbb7c33c77e1d3",
            "108ac4fa4ef7f2622b97a1f5dd92a3e0c6857c60",
            "0a5bc04095a675662cf24757cc0640aa2204253b",
        ]
        XCTAssertEqual(packages.map(\.revision), expectedRevisions)
        
        let expectedRepositoryURLs = [
            "https://github.com/apple/swift-algorithms",
            "https://github.com/apple/swift-argument-parser",
            "https://github.com/apple/swift-collections",
            "https://github.com/apple/swift-numerics",
        ]
        XCTAssertEqual(packages.map(\.location), expectedRepositoryURLs)
        
        let expectedLicenseLengths = [11_751, 11_751, 11_751, 11_751]
        XCTAssertEqual(packages.map(\.license?.count), expectedLicenseLengths)
    }
    
    func testErrors() {
        let packageProvider = JSONPackageProvider(bundle: .module, fileName: "test")
        XCTAssertThrowsError(try packageProvider.packages()) { error in
            let cocoaError = error as? CocoaError
            XCTAssertNotNil(cocoaError)
            XCTAssertEqual(cocoaError?.code, .fileNoSuchFile)
            XCTAssertEqual(cocoaError?.userInfo["file_name"] as? String, "test")
            XCTAssertEqual(cocoaError?.userInfo["file_type"] as? String, "json")
        }
    }
}
