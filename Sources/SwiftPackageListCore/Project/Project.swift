//
//  Project.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 15.03.22.
//

import Foundation
import SwiftPackageList

public protocol Project {
    var fileURL: URL { get }
    var options: ProjectOptions { get }
    var name: String { get }
    var organizationName: String? { get }
    
    func packages() throws -> [Package]
}

extension Project {
    var organizationName: String? {
        return nil
    }
}
