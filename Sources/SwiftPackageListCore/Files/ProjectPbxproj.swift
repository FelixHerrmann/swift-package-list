//
//  ProjectPbxproj.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 26.12.23.
//

import Foundation

struct ProjectPbxproj: File {
    let url: URL
}

extension ProjectPbxproj {
    var organizationName: String? {
        do {
            let contents = try String(contentsOf: url)
            let organizationNames = try regex("(?<=ORGANIZATIONNAME = \").*(?=\";)", on: contents)
            if organizationNames.isEmpty {
                let organizationNamesWithoutQuotes = try regex("(?<=ORGANIZATIONNAME = ).*(?=;)", on: contents)
                return organizationNamesWithoutQuotes.first
            } else {
                return organizationNames.first
            }
        } catch {
            return nil
        }
    }
}
