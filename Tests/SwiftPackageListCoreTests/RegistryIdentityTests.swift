//
//  RegistryIdentityTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 02.03.25.
//

import XCTest
@testable import SwiftPackageListCore

final class RegistryIdentityTests: XCTestCase {
    func testIdentityInitNoComponents() {
        let identity = RegistryIdentity(identity: "")
        XCTAssertNil(identity)
    }
    
    func testIdentityInitSingleComponent() {
        let identity = RegistryIdentity(identity: "scope")
        XCTAssertNil(identity)
    }
    
    func testIdentityInitTwoComponents() throws {
        let identity = try XCTUnwrap(RegistryIdentity(identity: "scope.name"))
        XCTAssertEqual(identity.scope, "scope")
        XCTAssertEqual(identity.name, "name")
    }
    
    func testIdentityInitMultipleComponents() throws {
        let identity = try XCTUnwrap(RegistryIdentity(identity: "scope.name.with.separators"))
        XCTAssertEqual(identity.scope, "scope")
        XCTAssertEqual(identity.name, "name.with.separators")
    }
}
