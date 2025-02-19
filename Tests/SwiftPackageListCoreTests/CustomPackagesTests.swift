//
//  CustomPackagesTests.swift
//  SwiftPackageList
//
//  Created by Felix Herrmann on 17.02.25.
//

import XCTest
@testable import SwiftPackageListCore

final class CustomPackagesTests: XCTestCase {
    func testPackageParsing() throws {
        let url = Bundle.module.url(
            forResource: "custom-packages",
            withExtension: ".json",
            subdirectory: "Resources/CustomPackages"
        )
        let unwrappedURL = try XCTUnwrap(url)
        let customPackages = CustomPackages(url: unwrappedURL)
        let package = try XCTUnwrap(try customPackages.packages().first)
        
        XCTAssertEqual(package.branch, "branch-test")
        XCTAssertEqual(package.identity, "identity-test")
        XCTAssertEqual(package.license, "license-test")
        XCTAssertEqual(package.location, "location-tes")
        XCTAssertEqual(package.name, "name-test")
        XCTAssertEqual(package.revision, "revision-test")
        XCTAssertEqual(package.version, "version-test")
    }
}
