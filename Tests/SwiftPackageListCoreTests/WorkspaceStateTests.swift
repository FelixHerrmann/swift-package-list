//
//  WorkspaceStateTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 10.12.23.
//

import XCTest
@testable import SwiftPackageListCore

final class WorkspaceStateTests: XCTestCase {
    func testVersion6() throws {
        let url = Bundle.module.url(
            forResource: "workspace-state_v6",
            withExtension: "json",
            subdirectory: "Resources/WorkspaceState"
        )
        let unwrappedURL = try XCTUnwrap(url)
        let workspaceState = try WorkspaceState(url: unwrappedURL)
        
        switch workspaceState.storage {
        case .v6(let workspaceState_V6):
            XCTAssertEqual(workspaceState_V6.version, 6)
            XCTAssertEqual(workspaceState_V6.object.artifacts[0].packageRef.identity, "intercom-ios-sp")
            XCTAssertEqual(workspaceState_V6.object.artifacts[0].packageRef.name, "Intercom")
            XCTAssertEqual(workspaceState_V6.object.dependencies[0].packageRef.identity, "collectionconcurrencykit")
            XCTAssertEqual(workspaceState_V6.object.dependencies[0].packageRef.name, "CollectionConcurrencyKit")
        default:
            XCTFail("\(unwrappedURL.path) was not recognized as v6")
        }
    }
    
    func testUnsupportedVersion() throws {
        let url = Bundle.module.url(
            forResource: "workspace-state_v999",
            withExtension: "json",
            subdirectory: "Resources/WorkspaceState"
        )
        let unwrappedURL = try XCTUnwrap(url)
        
        XCTAssertThrowsError(try WorkspaceState(url: unwrappedURL)) { error in
            XCTAssertTrue(error is RuntimeError)
            XCTAssertEqual((error as? RuntimeError)?.description, "Version 999 of workspace-state.json is not supported")
        }
    }
}
