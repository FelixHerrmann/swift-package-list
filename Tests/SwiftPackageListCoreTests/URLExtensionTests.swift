//
//  URLExtensionTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 14.02.24.
//

import XCTest
@testable import SwiftPackageListCore

final class URLExtensionTests: XCTestCase {
    func testPackageIdentity() throws {
        let plain = try XCTUnwrap(URL(string: "https://github.com/test/test"))
        XCTAssertEqual(plain.packageIdentity, "test")
        
        let plainExtension = try XCTUnwrap(URL(string: "https://github.com/test/test.git"))
        XCTAssertEqual(plainExtension.packageIdentity, "test")
        
        let prefix = try XCTUnwrap(URL(string: "https://github.com/test/swift-test"))
        XCTAssertEqual(prefix.packageIdentity, "swift-test")
        
        let prefixExtension = try XCTUnwrap(URL(string: "https://github.com/test/swift-test.git"))
        XCTAssertEqual(prefixExtension.packageIdentity, "swift-test")
        
        let `extension` = try XCTUnwrap(URL(string: "https://github.com/test/Test.swift"))
        XCTAssertEqual(`extension`.packageIdentity, "Test.swift")
        
        let extensionExtension = try XCTUnwrap(URL(string: "https://github.com/test/Test.swift.git"))
        XCTAssertEqual(extensionExtension.packageIdentity, "Test.swift")
    }
}
