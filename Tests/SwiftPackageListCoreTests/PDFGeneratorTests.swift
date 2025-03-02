//
//  PDFGeneratorTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 16.05.22.
//

import XCTest
import PDFKit
import SwiftPackageList
@testable import SwiftPackageListCore

final class PDFGeneratorTests: XCTestCase {
    
    private let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("Acknowledgements.pdf")
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let url = try XCTUnwrap(
            Bundle.module.url(
                forResource: "Project",
                withExtension: "xcodeproj",
                subdirectory: "Resources/XcodeProject"
            )
        )
        let projectType = try XCTUnwrap(ProjectType(fileURL: url))
        let project = try projectType.project(fileURL: url)
        let package = Package(
            kind: .remoteSourceControl,
            identity: "test",
            name: "test",
            version: "1.0.0",
            branch: nil,
            revision: "xxxx",
            location: "https://github.com/test/test",
            license: "MIT"
        )
        
        let pdfGenerator = PDFGenerator(outputURL: outputURL, packages: [package], project: project)
        try pdfGenerator.generateOutput()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        try FileManager.default.removeItem(at: outputURL)
    }
    
    func testOutput() throws {
        let output = try XCTUnwrap(PDFDocument(url: outputURL))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd.yyyy"
        let creationDate = dateFormatter.string(from: Date())
        
        let attributes = try XCTUnwrap(output.documentAttributes)
        XCTAssertEqual(attributes["Author"] as? String, "SwiftPackageList")
        XCTAssertEqual(attributes["Subject"] as? String, "Project Acknowledgements")
        XCTAssertEqual(attributes["Title"] as? String, "Project_Acks_File_\(creationDate)")
        XCTAssertEqual(attributes["Creator"] as? String, "swift-package-list")
        
        let expectedOutput: String
        if #available(macOS 15.0, *) {
            expectedOutput = """
            Acknowledgements
            Portions of this SwiftPackageList Software may utilize the following copyrighted
            material, the use of which is hereby acknowledged.
            test
            MIT
            """
        } else {
            expectedOutput = """
            Acknowledgements
            Portions of this SwiftPackageList Software may utilize the following \
            copyrighted material, the use of which is hereby acknowledged.
            test
            MIT
            
            """
        }
        XCTAssertEqual(output.string, expectedOutput)
    }
}
