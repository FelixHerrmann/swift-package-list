//
//  SwiftPackageListPlugin.swift
//  SwiftPackageListPlugin
//
//  Created by Felix Herrmann on 03.02.24.
//

import Foundation
import PackagePlugin

@main
struct SwiftPackageListPlugin: Plugin {
    func createBuildCommands(
        executable: Path,
        targetConfiguration: Configuration.TargetConfiguration?,
        projectPath: Path,
        pluginWorkDirectory: Path
    ) throws -> [Command] {
        let outputType = targetConfiguration?.outputType ?? .json
        let outputPath = pluginWorkDirectory
        let requiresLicense = targetConfiguration?.requiresLicense ?? true
        
        let ignorePackageArguments: [String] = targetConfiguration?.ignorePackages?.flatMap { identity in
            return ["--ignore-package", identity]
        } ?? []
        
        let customPackagesFilePathArguments: [String] = targetConfiguration?.customPackagesFilePaths?.flatMap { filePath in
            return ["--custom-packages-file-path", filePath]
        } ?? []
        
        let outputFiles: [Path]
        if let fileName = outputType.fileName {
            outputFiles = [outputPath.appending(fileName)]
        } else {
            outputFiles = []
        }
        
        return [
            .buildCommand(
                displayName: "SwiftPackageListPlugin",
                executable: executable,
                arguments: [
                    projectPath,
                    "--output-type", outputType.rawValue,
                    "--output-path", outputPath,
                    requiresLicense ? "--requires-license" : "",
                ] + ignorePackageArguments + customPackagesFilePathArguments,
                outputFiles: outputFiles
            )
        ]
    }
}
