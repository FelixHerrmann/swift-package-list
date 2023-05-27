//
//  SwiftPackageListPDFPlugin.swift
//  SwiftPackageListPDFPlugin
//
//  Created by Felix Herrmann on 27.05.23.
//

import Foundation
import PackagePlugin

@main
struct SwiftPackageListPDFPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        return []
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftPackageListPDFPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let projectPath = context.xcodeProject.directory.appending("\(context.xcodeProject.displayName).xcodeproj")
        let executable = try context.tool(named: "SwiftPackageListCommand").path
            .removingLastComponent()
            .appending("swift-package-list")
        let outputPath = context.pluginWorkDirectory
        let fileType = "pdf"
        return [
            .buildCommand(
                displayName: "SwiftPackageListPlugin",
                executable: executable,
                arguments: ["generate", projectPath, "--output-path", outputPath, "--file-type", fileType, "--requires-license"],
                outputFiles: [outputPath.appending("Acknowledgements.pdf")]
            )
        ]
    }
}
#endif
