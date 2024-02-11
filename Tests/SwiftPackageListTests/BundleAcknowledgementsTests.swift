//
//  BundleAcknowledgementsTests.swift
//  SwiftPackageListTests
//
//  Created by Felix Herrmann on 11.02.24.
//

import XCTest
@testable import SwiftPackageList

final class BundleAcknowledgementsTests: XCTestCase {
    func testURL() {
        let expectedURL = Bundle.module.bundleURL
            .appendingPathComponent("Contents")
            .appendingPathComponent("Resources")
            .appendingPathComponent("Acknowledgements")
            .appendingPathExtension("pdf")
        
        XCTAssertEqual(Bundle.module.acknowledgementsURL, expectedURL)
    }
    
    func testPath() {
        let expectedPath = Bundle.module.bundlePath
            .appending("/Contents")
            .appending("/Resources")
            .appending("/Acknowledgements.pdf")
        
        XCTAssertEqual(Bundle.module.acknowledgementsPath, expectedPath)
    }
}
