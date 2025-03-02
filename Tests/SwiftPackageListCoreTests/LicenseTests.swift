//
//  LicenseTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 02.03.25.
//

import XCTest
@testable import SwiftPackageListCore

final class LicenseTests: XCTestCase {
    func testInitUncheckedURLDisallowed() {
        XCTAssertNil(License(uncheckedURL: URL(fileURLWithPath: "/test/TEST")))
    }
    
    func testInitUncheckedURLAllowed() {
        XCTAssertNotNil(License(uncheckedURL: URL(fileURLWithPath: "/test/LICENSE")))
        XCTAssertNotNil(License(uncheckedURL: URL(fileURLWithPath: "/test/Licence")))
        XCTAssertNotNil(License(uncheckedURL: URL(fileURLWithPath: "/test/copying")))
    }
}
