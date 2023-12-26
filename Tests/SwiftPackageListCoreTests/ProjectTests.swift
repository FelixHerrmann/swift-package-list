//
//  ProjectTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 15.05.22.
//

import XCTest
@testable import SwiftPackageListCore

final class ProjectTests: XCTestCase {
    func testProject() throws {
        // Note: The project and workspace files in the Resources directory get's hidden by Xcode
        let url = Bundle.module.url(forResource: "Project", withExtension: "xcodeproj", subdirectory: "Resources")
        let unwrappedURL = try XCTUnwrap(url)
        let projectType = try XCTUnwrap(ProjectType(fileURL: unwrappedURL))
        let project = projectType.project(fileURL: unwrappedURL)
        
        let expectedPackageResolvedFileURL = "\(unwrappedURL.path)/project.xcworkspace/xcshareddata/swiftpm/Package.resolved"
        XCTAssertEqual(project.packageResolvedFileURL.path, expectedPackageResolvedFileURL)
        XCTAssertEqual(project.projectPbxproj?.organizationName, "SwiftPackageList")
    }
    
    func testWorkspace() throws {
        // Note: The project and workspace files in the Resources directory get's hidden by Xcode
        let url = Bundle.module.url(forResource: "Workspace", withExtension: "xcworkspace", subdirectory: "Resources")
        let unwrappedURL = try XCTUnwrap(url)
        let projectType = try XCTUnwrap(ProjectType(fileURL: unwrappedURL))
        let project = projectType.project(fileURL: unwrappedURL)
        
        let expectedPackageResolvedFileURL = "\(unwrappedURL.path)/xcshareddata/swiftpm/Package.resolved"
        XCTAssertEqual(project.packageResolvedFileURL.path, expectedPackageResolvedFileURL)
        XCTAssertEqual(project.projectPbxproj?.organizationName, "SwiftPackageList")
    }
}
