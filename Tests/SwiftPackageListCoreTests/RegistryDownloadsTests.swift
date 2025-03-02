//
//  RegistryDownloadsTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 02.03.25.
//

import XCTest
@testable import SwiftPackageListCore

final class RegistryDownloadsTests: XCTestCase {
    func testPackageSourceMissingVersion() {
        let registryDownloads = RegistryDownloads(url: URL(fileURLWithPath: "/test/registry/downloads"))
        let packageSource = registryDownloads.packageSource(identity: "", version: nil)
        XCTAssertNil(packageSource)
    }
    
    func testPackageSourceInvalidIdentity() {
        let registryDownloads = RegistryDownloads(url: URL(fileURLWithPath: "/test/registry/downloads"))
        let packageSource = registryDownloads.packageSource(identity: "scope", version: "1.0.0")
        XCTAssertNil(packageSource)
    }
    
    func testPackageSourceValidIdentity() throws {
        let registryDownloads = RegistryDownloads(url: URL(fileURLWithPath: "/test/registry/downloads"))
        let packageSource = try XCTUnwrap(registryDownloads.packageSource(identity: "scope.name", version: "1.0.0"))
        XCTAssertEqual(packageSource.url.path(), "/test/registry/downloads/scope/name/1.0.0")
    }
}
