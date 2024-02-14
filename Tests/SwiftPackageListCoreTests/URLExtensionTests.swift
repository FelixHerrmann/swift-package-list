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
        let a = try XCTUnwrap(URL(string: "https://github.com/test/test"))
        XCTAssertEqual(a.packageIdentity, "test")
        
        let b = try XCTUnwrap(URL(string: "https://github.com/test/swift-test"))
        XCTAssertEqual(b.packageIdentity, "swift-test")
        
        let c = try XCTUnwrap(URL(string: "https://github.com/test/Test.swift"))
        XCTAssertEqual(c.packageIdentity, "Test.swift")
        
        let d = try XCTUnwrap(URL(string: "https://github.com/test/Test.swift.git"))
        XCTAssertEqual(d.packageIdentity, "Test.swift")
    }
}
