//
//  PDFGenerator.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 11.04.22.
//

import AppKit
import SwiftPackageList

struct PDFGenerator: OutputGenerator {
    let outputURL: URL
    let packages: [Package]
    let projectName: String
    let organizationName: String?
    
    init(outputURL: URL, packages: [Package], project: some Project) {
        self.outputURL = outputURL
        self.packages = packages
        self.projectName = project.name
        
        if let organizationName = project.organizationName {
            self.organizationName = organizationName
        } else {
            print("Warning: Could not find the organization name in your project")
            self.organizationName = nil
        }
    }
    
    func generateOutput() throws {
        guard let consumer = CGDataConsumer(url: outputURL as CFURL) else {
            throw RuntimeError("Something is wrong with the output-path")
        }
        let auxiliaryInfo = createAuxiliaryInfo()
        guard let context = CGContext(consumer: consumer, mediaBox: nil, auxiliaryInfo) else {
            throw RuntimeError("The PDF could not be created")
        }
        
        let attributedString = try buildAttributedString()
        
        while !attributedString.string.isEmpty {
            context.beginPage(mediaBox: nil)
            
            let framesetter = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)
            let range = CFRange(location: 0, length: attributedString.length)
            let rect = calculateDrawableRect(in: context)
            let path = CGPath(rect: rect, transform: nil)
            let frame = CTFramesetterCreateFrame(framesetter, range, path, nil)
            CTFrameDraw(frame, context)
            
            let length = CTFrameGetVisibleStringRange(frame).length
            attributedString.deleteCharacters(in: NSRange(location: 0, length: length))
            
            context.endPage()
        }
        
        context.closePDF()
        
        print("Generated \(outputURL.path)")
    }
    
    private func createAuxiliaryInfo() -> CFDictionary {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd.yyyy"
        let creationDate = dateFormatter.string(from: Date())
        
        return [
            kCGPDFContextTitle: "\(projectName)_Acks_File_\(creationDate)",
            kCGPDFContextAuthor: organizationName,
            kCGPDFContextSubject: "\(projectName) Acknowledgements",
            kCGPDFContextCreator: "swift-package-list",
        ] as CFDictionary
    }
    
    private func buildAttributedString() throws -> NSMutableAttributedString {
        guard let defaultFont = NSFont(name: "Helvetica", size: 12) else {
            throw RuntimeError("Font \"Helvetica\" not available")
        }
        guard let boldFont = NSFont(name: "Helvetica Bold", size: 12) else {
            throw RuntimeError("Font \"Helvetica Bold\" not available")
        }
        
        let attributedString = NSMutableAttributedString()
        
        let headerTitle = NSAttributedString(string: "Acknowledgements", attributes: [.font: boldFont])
        attributedString.append(headerTitle)
        attributedString.append(NSAttributedString(string: "\n", attributes: [.font: defaultFont]))
        
        let organizationText = organizationName.map { $0 + " " } ?? ""
        let headerString = """
        Portions of this \(organizationText)Software may utilize the following copyrighted material, \
        the use of which is hereby acknowledged.
        """
        let header = NSAttributedString(string: headerString, attributes: [.font: defaultFont])
        attributedString.append(header)
        attributedString.append(NSAttributedString(string: "\n\n", attributes: [.font: defaultFont]))
        
        for package in packages {
            let packageName = NSAttributedString(string: package.name, attributes: [.font: boldFont])
            attributedString.append(packageName)
            
            attributedString.append(NSAttributedString(string: "\n", attributes: [.font: defaultFont]))
            
            let licenseString = (package.license ?? "No license")
                .replacingOccurrences(of: "\n", with: " ")
                .replacingOccurrences(of: " {2,}", with: " ", options: .regularExpression)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            let packageLicense = NSAttributedString(string: licenseString, attributes: [.font: defaultFont])
            attributedString.append(packageLicense)
            
            if package != packages.last {
                attributedString.append(NSAttributedString(string: "\n\n", attributes: [.font: defaultFont]))
            }
        }
        
        return attributedString
    }
    
    private func calculateDrawableRect(in context: CGContext) -> CGRect {
        let boxRect = context.boundingBoxOfClipPath
        let insets = NSEdgeInsets(top: 80, left: 80, bottom: 80, right: 80)
        
        let x = boxRect.origin.x + insets.left
        let y = boxRect.origin.y + insets.top
        let width = boxRect.width - (insets.left + insets.right)
        let height = boxRect.height - (insets.top + insets.bottom)
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
