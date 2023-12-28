//
//  ProjectPbxprojTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 26.12.23.
//

import XCTest
@testable import SwiftPackageListCore

final class ProjectPbxprojTests: XCTestCase {
    func testOrganizationName() throws {
        let url = Bundle.module.url(forResource: "project", withExtension: "pbxproj", subdirectory: "Resources/Project.xcodeproj")
        let unwrappedURL = try XCTUnwrap(url)
        let projectPbxproj = ProjectPbxproj(url: unwrappedURL)
        
        XCTAssertEqual(projectPbxproj.organizationName, "SwiftPackageList")
    }
}
