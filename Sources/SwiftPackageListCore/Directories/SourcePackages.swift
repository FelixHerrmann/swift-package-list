//
//  SourcePackages.swift
//  SwiftPackgageListCore
//
//  Created by Felix Herrmann on 26.12.23.
//

import Foundation
import SwiftPackageList

struct SourcePackages: Directory {
    let url: URL
}

extension SourcePackages {
    var checkouts: Checkouts {
        let checkoutsURL = url.appendingPathComponent("checkouts")
        return Checkouts(url: checkoutsURL)
    }
    
    var workspaceState: WorkspaceState {
        get throws {
            let fileURL = url.appendingPathComponent("workspace-state.json")
            return try WorkspaceState(url: fileURL)
        }
    }
}
