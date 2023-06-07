//
//  SwiftPackageListJSONPlugin.swift
//  SwiftPackageListJSONPlugin
//
//  Created by Felix Herrmann on 22.05.23.
//

import Foundation
import PackagePlugin

@main
struct SwiftPackageListJSONPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        return []
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftPackageListJSONPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let projectPath = context.xcodeProject.directory.appending("\(context.xcodeProject.displayName).xcodeproj")
        let executable = try context.tool(named: "swift-package-list").path
        let outputPath = context.pluginWorkDirectory
        let fileType = "json"
        let derivedDataPath = context.derivedDataDirectory
        return [
            .buildCommand(
                displayName: "SwiftPackageListPlugin",
                executable: executable,
                arguments: [
                    "generate",
                    projectPath,
                    "--derived-data-path", derivedDataPath,
                    "--output-path", outputPath,
                    "--file-type", fileType,
                    "--requires-license"
                ],
                outputFiles: [outputPath.appending("package-list.json")]
            )
        ]
    }
}

extension XcodePluginContext {
    var derivedDataDirectory: Path {
        var path = pluginWorkDirectory
        while path.lastComponent != "DerivedData" {
            guard path.string != "/" else {
                return Path("\(NSHomeDirectory())/Library/Developer/Xcode/DerivedData")
            }
            path = path.removingLastComponent()
        }
        return path
    }
}
#endif
