//
//  Regex.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 21.12.23.
//

import Foundation

func regex(_ pattern: String, on fileContent: String) throws -> [String] {
    let regex = try NSRegularExpression(pattern: pattern)
    let matches = regex.matches(in: fileContent, range: NSRange(location: 0, length: fileContent.count))
    return matches.compactMap { result in
        guard let range = Range(result.range, in: fileContent) else { return nil }
        return String(fileContent[range])
    }
}
