//
//  OutputGenerator.swift
//  SwiftPackageListCommand
//
//  Created by Felix Herrmann on 15.05.22.
//

import Foundation
import SwiftPackageList

protocol OutputGenerator {
    init(outputURL: URL, packages: [Package], project: Project)
    func generateOutput() throws
}
