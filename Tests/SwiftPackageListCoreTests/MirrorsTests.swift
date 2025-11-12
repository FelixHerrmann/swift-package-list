//
//  MirrorsTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 09.11.25.
//

import XCTest
@testable import SwiftPackageListCore

final class MirrorsTests: XCTestCase {
    func testVersion1() throws {
        let url = Bundle.module.url(
            forResource: "mirrors_v1",
            withExtension: "json",
            subdirectory: "Resources/Mirrors"
        )
        let unwrappedURL = try XCTUnwrap(url)
        let mirrors = try Mirrors(url: unwrappedURL)
        
        guard case .v1(let storage) = mirrors.storage else {
            XCTFail("\(unwrappedURL.path) was not recognized as v1")
            return
        }
        
        XCTAssertEqual(storage.version, 1)
        XCTAssertEqual(storage.object.count, 2)
    }
    
    func testUnsupportedVersion() throws {
        let url = Bundle.module.url(
            forResource: "mirrors_v999",
            withExtension: "json",
            subdirectory: "Resources/Mirrors"
        )
        let unwrappedURL = try XCTUnwrap(url)
        
        XCTAssertThrowsError(try Mirrors(url: unwrappedURL)) { error in
            XCTAssertTrue(error is RuntimeError)
            XCTAssertEqual((error as? RuntimeError)?.description, "Version 999 of mirrors.json is not supported")
        }
    }
    
    func testMirror() throws {
        let url = Bundle.module.url(
            forResource: "mirrors_v1",
            withExtension: "json",
            subdirectory: "Resources/Mirrors"
        )
        let unwrappedURL = try XCTUnwrap(url)
        let mirrors = try Mirrors(url: unwrappedURL)
        
        XCTAssertEqual(mirrors.mirror(for: "https://github.com/FelixHerrmann/swift-package-list"), "https://github.com/example/swift-package-list")
        XCTAssertEqual(mirrors.mirror(for: "https://github.com/FelixHerrmann/test"), "/Users/example/test")
    }
}
