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
        let url = Bundle.module.url(
            forResource: "Package_v1",
            withExtension: "resolved",
            subdirectory: "Resources/PackageResolved"
        )
        let unwrappedURL = try XCTUnwrap(url)
        let packageResolved = try PackageResolved(url: unwrappedURL)
        
        switch packageResolved.storage {
        case .v1(let packageResolved_V1):
            XCTAssertEqual(packageResolved_V1.version, 1)
            XCTAssertEqual(packageResolved_V1.object.pins[0].package, "SwiftPackageList")
            XCTAssertEqual(packageResolved_V1.object.pins[0].repositoryURL, "https://github.com/FelixHerrmann/swift-package-list")
            XCTAssertNil(packageResolved_V1.object.pins[0].state.branch)
            XCTAssertEqual(packageResolved_V1.object.pins[0].state.revision, "3a1b45c9e994aebaf47e8c4bd631bd79075f4abb")
            XCTAssertEqual(packageResolved_V1.object.pins[0].state.version, "1.0.1")
        default:
            XCTFail("\(unwrappedURL.path) was not recognized as v1")
        }
    }
    
    func testVersion2() throws {
        let url = Bundle.module.url(
            forResource: "Package_v2",
            withExtension: "resolved",
            subdirectory: "Resources/PackageResolved"
        )
        let unwrappedURL = try XCTUnwrap(url)
        let packageResolved = try PackageResolved(url: unwrappedURL)
        
        switch packageResolved.storage {
        case .v2(let packageResolved_V2):
            XCTAssertEqual(packageResolved_V2.version, 2)
            XCTAssertEqual(packageResolved_V2.pins[0].identity, "swift-package-list")
            XCTAssertEqual(packageResolved_V2.pins[0].kind, "remoteSourceControl")
            XCTAssertEqual(packageResolved_V2.pins[0].location, "https://github.com/FelixHerrmann/swift-package-list")
            XCTAssertNil(packageResolved_V2.pins[0].state.branch)
            XCTAssertEqual(packageResolved_V2.pins[0].state.revision, "3a1b45c9e994aebaf47e8c4bd631bd79075f4abb")
            XCTAssertEqual(packageResolved_V2.pins[0].state.version, "1.0.1")
        default:
            XCTFail("\(unwrappedURL.path) was not recognized as v2")
        }
    }
    
    func testUnsupportedVersion() throws {
        let url = Bundle.module.url(
            forResource: "Package_v999",
            withExtension: "resolved",
            subdirectory: "Resources/PackageResolved"
        )
        let unwrappedURL = try XCTUnwrap(url)
        
        XCTAssertThrowsError(try PackageResolved(url: unwrappedURL)) { error in
            XCTAssertTrue(error is RuntimeError)
            XCTAssertEqual((error as? RuntimeError)?.description, "Version 999 of Package.resolved is not supported")
        }
    }
    
    func testVersion1IdentityConstruction() {
        let remotePin = PackageResolved.Storage.V1.Object.Pin(
            package: "",
            repositoryURL: "https://github.com/test/TestRemote.git",
            state: PackageResolved.Storage.V1.Object.Pin.State(branch: nil, revision: "", version: nil)
        )
        let localPin = PackageResolved.Storage.V1.Object.Pin(
            package: "",
            repositoryURL: "/Users/test/Desktop/TestLocal/",
            state: PackageResolved.Storage.V1.Object.Pin.State(branch: nil, revision: "", version: nil)
        )
        
        XCTAssertEqual(remotePin.identity, "testremote")
        XCTAssertEqual(localPin.identity, "testlocal")
    }
}
