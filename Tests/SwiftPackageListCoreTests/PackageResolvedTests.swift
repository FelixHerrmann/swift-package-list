//
//  PackageResolvedTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 15.05.22.
//

import XCTest
@testable import SwiftPackageListCore

final class PackageResolvedTests: XCTestCase {
    
    func testVersion1() throws {
        let url = try XCTUnwrap(Bundle.module.url(forResource: "Package_v1", withExtension: "resolved", subdirectory: "Resources"))
        let packageResolved = try PackageResolved(at: url)
        switch packageResolved {
        case .v1(let packageResolved_V1):
            XCTAssertEqual(packageResolved_V1.version, 1)
            XCTAssertEqual(packageResolved_V1.object.pins[0].package, "SwiftPackageList")
            XCTAssertEqual(packageResolved_V1.object.pins[0].repositoryURL, "https://github.com/FelixHerrmann/swift-package-list")
            XCTAssertEqual(packageResolved_V1.object.pins[0].state.branch, nil)
            XCTAssertEqual(packageResolved_V1.object.pins[0].state.revision, "3a1b45c9e994aebaf47e8c4bd631bd79075f4abb")
            XCTAssertEqual(packageResolved_V1.object.pins[0].state.version, "1.0.1")
        default:
            XCTFail("\(url.path) was not recognized as v1")
        }
    }
    
    func testVersion2() throws {
        let url = try XCTUnwrap(Bundle.module.url(forResource: "Package_v2", withExtension: "resolved", subdirectory: "Resources"))
        let packageResolved = try PackageResolved(at: url)
        switch packageResolved {
        case .v2(let packageResolved_V2):
            XCTAssertEqual(packageResolved_V2.version, 2)
            XCTAssertEqual(packageResolved_V2.pins[0].identity, "swift-package-list")
            XCTAssertEqual(packageResolved_V2.pins[0].kind, "remoteSourceControl")
            XCTAssertEqual(packageResolved_V2.pins[0].location, "https://github.com/FelixHerrmann/swift-package-list")
            XCTAssertEqual(packageResolved_V2.pins[0].state.branch, nil)
            XCTAssertEqual(packageResolved_V2.pins[0].state.revision, "3a1b45c9e994aebaf47e8c4bd631bd79075f4abb")
            XCTAssertEqual(packageResolved_V2.pins[0].state.version, "1.0.1")
        default:
            XCTFail("\(url.path) was not recognized as v2")
        }
    }
    
    func testUnsupportedVersion() throws {
        let url = try XCTUnwrap(Bundle.module.url(forResource: "Package_v999", withExtension: "resolved", subdirectory: "Resources"))
        XCTAssertThrowsError(try PackageResolved(at: url)) { error in
            XCTAssertTrue(error is RuntimeError)
            XCTAssertEqual((error as? RuntimeError)?.description, "The version of the Package.resolved is not supported")
        }
    }
}
