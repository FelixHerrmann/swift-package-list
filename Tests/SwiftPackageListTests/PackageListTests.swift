//
//  PackageListTests.swift
//  SwiftPackageListTests
//
//  Created by Felix Herrmann on 15.05.22.
//

import XCTest
@testable import SwiftPackageList

final class PackageListTests: XCTestCase {
    
    func testJSON() throws {
        let packages = try packageList(bundle: .module, fileName: "example_1")
        
        XCTAssertEqual(packages.map(\.name), ["swift-algorithms", "swift-argument-parser", "swift-collections", "swift-numerics"])
        XCTAssertEqual(packages.map(\.version), ["1.0.0", nil, nil, "1.0.2"])
        XCTAssertEqual(packages.map(\.branch), [nil, nil, "main", nil])
        XCTAssertEqual(packages.map(\.revision), ["b14b7f4c528c942f121c8b860b9410b2bf57825e", "060d52364cf2a3e06b7adf0b17dbb7c33c77e1d3", "108ac4fa4ef7f2622b97a1f5dd92a3e0c6857c60", "0a5bc04095a675662cf24757cc0640aa2204253b"])
        XCTAssertEqual(packages.map(\.repositoryURL.absoluteString), ["https://github.com/apple/swift-algorithms", "https://github.com/apple/swift-argument-parser", "https://github.com/apple/swift-collections", "https://github.com/apple/swift-numerics"])
        XCTAssertEqual(packages.map(\.license?.count), [11751, 11751, 11751, 11751])
    }
    
    func testPropertyList() throws {
        let packages = try packageList(bundle: .module, fileName: "example_2")
        
        XCTAssertEqual(packages.map(\.name), ["swift-algorithms", "swift-argument-parser", "swift-collections", "swift-numerics"])
        XCTAssertEqual(packages.map(\.version), ["1.0.0", nil, nil, "1.0.2"])
        XCTAssertEqual(packages.map(\.branch), [nil, nil, "main", nil])
        XCTAssertEqual(packages.map(\.revision), ["b14b7f4c528c942f121c8b860b9410b2bf57825e", "060d52364cf2a3e06b7adf0b17dbb7c33c77e1d3", "108ac4fa4ef7f2622b97a1f5dd92a3e0c6857c60", "0a5bc04095a675662cf24757cc0640aa2204253b"])
        XCTAssertEqual(packages.map(\.repositoryURL.absoluteString), ["https://github.com/apple/swift-algorithms", "https://github.com/apple/swift-argument-parser", "https://github.com/apple/swift-collections", "https://github.com/apple/swift-numerics"])
        XCTAssertEqual(packages.map(\.license?.count), [11751, 11751, 11751, 11751])
    }
    
    func testErrors() {
        XCTAssertThrowsError(try packageList(bundle: .module, fileName: "test")) { error in
            XCTAssertTrue(error is PackageListError)
            XCTAssertEqual(error as? PackageListError, .noPackageList)
        }
    }
}
