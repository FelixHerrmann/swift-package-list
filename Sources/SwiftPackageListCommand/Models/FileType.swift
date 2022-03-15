//
//  FileType.swift
//  SwiftPackageListCommand
//
//  Created by Felix Herrmann on 15.03.22.
//

import Foundation
import ArgumentParser

enum FileType: String, CaseIterable, ExpressibleByArgument {
    case json
    case plist
}
