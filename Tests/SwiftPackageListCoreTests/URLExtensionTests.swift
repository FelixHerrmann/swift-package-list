//
//  URLExtensionTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 14.02.24.
//

import XCTest
@testable import SwiftPackageListCore

final class URLExtensionTests: XCTestCase {
    func testDeletingGitExtensionNoExtension() throws {
        let url = try XCTUnwrap(URL(string: "https://github.com/test/test"))
            .deletingGitExtension()
            .absoluteString
        XCTAssertEqual(url, "https://github.com/test/test")
    }
    
    func testDeletingGitExtensionGitExtension() throws {
        let url = try XCTUnwrap(URL(string: "https://github.com/test/test.git"))
            .deletingGitExtension()
            .absoluteString
        XCTAssertEqual(url, "https://github.com/test/test")
    }
    
    func testDeletingGitExtensionOtherExtension() throws {
        let url = try XCTUnwrap(URL(string: "https://github.com/test/Test.swift"))
            .deletingGitExtension()
            .absoluteString
        XCTAssertEqual(url, "https://github.com/test/Test.swift")
    }
    
    func testDeletingGitExtensionMixedExtensions() throws {
        let url = try XCTUnwrap(URL(string: "https://github.com/test/Test.swift.git"))
            .deletingGitExtension()
            .absoluteString
        XCTAssertEqual(url, "https://github.com/test/Test.swift")
    }
}
