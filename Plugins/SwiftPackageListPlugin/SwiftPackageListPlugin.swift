//
//  SwiftPackageListPlugin.swift
//  SwiftPackageListPlugin
//
//  Created by Felix Herrmann on 03.02.24.
//

import PackagePlugin

@main
struct SwiftPackageListPlugin: Plugin {
    func createBuildCommands(
        executable: Path,
        targetConfiguration: Configuration.TargetConfiguration?,
        projectPath: Path,
        pluginWorkDirectory: Path
    ) throws -> [Command] {
        let sourcePackagesPath = try sourcePackagesDirectory(pluginWorkDirectory: pluginWorkDirectory)
        let outputType = targetConfiguration?.outputType ?? .json
        let outputPath = pluginWorkDirectory
        let requiresLicense = targetConfiguration?.requiresLicense ?? true
        
        let ignorePackageArguments: [String] = targetConfiguration?.ignorePackages?.flatMap { identity in
            return ["--ignore-package", identity]
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
                    "--custom-source-packages-path", sourcePackagesPath,
                    "--output-type", outputType.rawValue,
                    "--output-path", outputPath,
                    requiresLicense ? "--requires-license" : "",
                ] + ignorePackageArguments,
                outputFiles: outputFiles
            )
        ]
    }
    
    private func sourcePackagesDirectory(pluginWorkDirectory: Path) throws -> Path {
        var path = pluginWorkDirectory
        while path.lastComponent != "SourcePackages" {
            guard path.string != "/" else {
                throw SwiftPackageListPlugin.Error.sourcePackagesNotFound(pluginWorkDirectory: pluginWorkDirectory)
            }
            path = path.removingLastComponent()
        }
        return path
    }
}
