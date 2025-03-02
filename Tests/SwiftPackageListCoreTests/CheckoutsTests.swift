//
//  CheckoutsTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 02.03.25.
//

import XCTest
@testable import SwiftPackageListCore

final class CheckoutsTests: XCTestCase {
    func testPackageSourceInvalidURL() {
        let checkouts = Checkouts(url: URL(fileURLWithPath: "/test/checkouts"))
        let packageSource = checkouts.packageSource(location: "")
        XCTAssertNil(packageSource)
    }
    
    func testPackageSourceValidURL() throws {
        let checkouts = Checkouts(url: URL(fileURLWithPath: "/test/checkouts"))
        let packageSource = try XCTUnwrap(checkouts.packageSource(location: "https://github.com/test/test-Test.git"))
        XCTAssertEqual(packageSource.url.path(), "/test/checkouts/test-Test")
    }
}
