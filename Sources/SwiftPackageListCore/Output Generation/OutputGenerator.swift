//
//  OutputGenerator.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 15.05.22.
//

import Foundation
import SwiftPackageList

public protocol OutputGenerator {
    init(outputURL: URL, packages: [Package], project: any Project)
    func generateOutput() throws
}
