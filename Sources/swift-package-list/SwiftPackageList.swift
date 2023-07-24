//
//  SwiftPackageList.swift
//  swift-package-list
//
//  Created by Felix Herrmann on 01.11.21.
//

import Foundation
import ArgumentParser

@main
struct SwiftPackageList: ParsableCommand {
    static var configuration: CommandConfiguration {
        return CommandConfiguration(
            discussion: "A command-line tool to get all used SPM-dependencies of an Xcode project or workspace.",
            version: "3.0.5",
            subcommands: [Scan.self, Generate.self]
        )
    }
}
