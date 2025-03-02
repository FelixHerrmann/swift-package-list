//
//  PackageKindTests.swift
//  SwiftPackageListTests
//
//  Created by Felix Herrmann on 02.03.25.
//

import XCTest
@testable import SwiftPackageList

final class PackageKindTests: XCTestCase {
    func testEquatableConformance() {
        XCTAssertEqual(Package.Kind.localSourceControl, Package.Kind(rawValue: "localSourceControl"))
        XCTAssertNotEqual(Package.Kind.remoteSourceControl, Package.Kind.registry)
    }
    
    func testHashableConformance() {
        XCTAssertEqual(Package.Kind.localSourceControl.hashValue, Package.Kind(rawValue: "localSourceControl").hashValue)
        XCTAssertNotEqual(Package.Kind.remoteSourceControl.hashValue, Package.Kind.registry.hashValue)
    }
    
    func testDecodableConformance() throws {
        struct Example: Decodable {
            let kind: Package.Kind
        }
        
        let decoder = JSONDecoder()
        let data = Data("{\"kind\":\"remoteSourceControl\"}".utf8)
        let example = try decoder.decode(Example.self, from: data)
        
        XCTAssertEqual(example.kind, .remoteSourceControl)
    }
    
    func testEncodableConformance() throws {
        struct Example: Encodable {
            let kind: Package.Kind
        }
        
        let encoder = JSONEncoder()
        let example = Example(kind: .remoteSourceControl)
        let data = try encoder.encode(example)
        
        XCTAssertEqual(data, Data("{\"kind\":\"remoteSourceControl\"}".utf8))
    }
}
