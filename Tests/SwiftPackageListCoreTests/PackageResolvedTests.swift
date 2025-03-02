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
        
        guard case .v1(let storage) = packageResolved.storage else {
            XCTFail("\(unwrappedURL.path) was not recognized as v1")
            return
        }
        
        XCTAssertEqual(storage.version, 1)
        XCTAssertEqual(storage.object.pins.count, 2)
        XCTAssertEqual(storage.object.pins[0].repositoryURL, "/Users/example/swift-package-list")
        XCTAssertEqual(storage.object.pins[1].repositoryURL, "https://github.com/FelixHerrmann/swift-package-list")
    }
    
    func testVersion2() throws {
        let url = Bundle.module.url(
            forResource: "Package_v2",
            withExtension: "resolved",
            subdirectory: "Resources/PackageResolved"
        )
        let unwrappedURL = try XCTUnwrap(url)
        let packageResolved = try PackageResolved(url: unwrappedURL)
        
        guard case .v2(let storage) = packageResolved.storage else {
            XCTFail("\(unwrappedURL.path) was not recognized as v2")
            return
        }
        
        XCTAssertEqual(storage.version, 2)
        XCTAssertEqual(storage.pins.count, 3)
        XCTAssertEqual(storage.pins[0].kind, .localSourceControl)
        XCTAssertEqual(storage.pins[1].kind, .remoteSourceControl)
        XCTAssertEqual(storage.pins[2].kind, .registry)
    }
    
    func testVersion3() throws {
        let url = Bundle.module.url(
            forResource: "Package_v3",
            withExtension: "resolved",
            subdirectory: "Resources/PackageResolved"
        )
        let unwrappedURL = try XCTUnwrap(url)
        let packageResolved = try PackageResolved(url: unwrappedURL)
        
        guard case .v3(let storage) = packageResolved.storage else {
            XCTFail("\(unwrappedURL.path) was not recognized as v3")
            return
        }
        
        XCTAssertEqual(storage.version, 3)
        XCTAssertEqual(storage.originHash, "0000000000000000000000000000000000000000000000000000000000000000")
        XCTAssertEqual(storage.pins.count, 3)
        XCTAssertEqual(storage.pins[0].kind, .localSourceControl)
        XCTAssertEqual(storage.pins[1].kind, .remoteSourceControl)
        XCTAssertEqual(storage.pins[2].kind, .registry)
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
    
    func testVersion1Kind() {
        let remotePin = PackageResolved.Storage.V1.Object.Pin(
            package: "",
            repositoryURL: "https://github.com/test/TestRemote.git",
            state: PackageResolved.Storage.V1.Object.Pin.State(branch: nil, revision: "", version: nil)
        )
        XCTAssertEqual(remotePin.kind, .remoteSourceControl)
        
        let localPin = PackageResolved.Storage.V1.Object.Pin(
            package: "",
            repositoryURL: "/Users/test/Desktop/TestLocal/",
            state: PackageResolved.Storage.V1.Object.Pin.State(branch: nil, revision: "", version: nil)
        )
        XCTAssertEqual(localPin.kind, .localSourceControl)
    }
    
    func testVersion1Identity() {
        let remotePin = PackageResolved.Storage.V1.Object.Pin(
            package: "",
            repositoryURL: "https://github.com/test/TestRemote.git",
            state: PackageResolved.Storage.V1.Object.Pin.State(branch: nil, revision: "", version: nil)
        )
        XCTAssertEqual(remotePin.identity, "testremote")
        
        let localPin = PackageResolved.Storage.V1.Object.Pin(
            package: "",
            repositoryURL: "/Users/test/Desktop/TestLocal/",
            state: PackageResolved.Storage.V1.Object.Pin.State(branch: nil, revision: "", version: nil)
        )
        XCTAssertEqual(localPin.identity, "testlocal")
    }
}
