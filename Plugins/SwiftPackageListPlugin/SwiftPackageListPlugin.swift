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
        let sourcePackagesPath = try sourcePackagesDirectory(
            pluginWorkDirectory: pluginWorkDirectory,
            customSourcePackagesDirectory: targetConfiguration?.customSourcePackagesPath
        )
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
                    "--custom-source-packages-path", sourcePackagesPath,
                    "--output-type", outputType.rawValue,
                    "--output-path", outputPath,
                    requiresLicense ? "--requires-license" : "",
                ] + ignorePackageArguments + customPackagesFilePathArguments,
                outputFiles: outputFiles
            )
        ]
    }
    
    private func sourcePackagesDirectory(
        pluginWorkDirectory: Path,
        customSourcePackagesDirectory: Path?
    ) throws -> Path {
        var path = pluginWorkDirectory
        var projectDirectory: String?
        while path.lastComponent != "DerivedData" {
            guard path.string != "/" else {
                throw SwiftPackageListPlugin.Error.sourcePackagesNotFound(pluginWorkDirectory: pluginWorkDirectory)
            }
            projectDirectory = path.lastComponent
            path = path.removingLastComponent()
        }
        
        guard let projectDirectory else {
            throw SwiftPackageListPlugin.Error.sourcePackagesNotFound(pluginWorkDirectory: pluginWorkDirectory)
        }
        var possibleSourcePackagesPaths = [
            path.appending([projectDirectory, "SourcePackages"]),
            path.appending("SourcePackages"),
        ]
        if let customSourcePackagesDirectory {
            possibleSourcePackagesPaths.append(customSourcePackagesDirectory)
        }
        let sourcePackagesPath = possibleSourcePackagesPaths.first { path in
            return FileManager.default.fileExists(atPath: path.string)
        }
        guard let sourcePackagesPath else {
            throw SwiftPackageListPlugin.Error.sourcePackagesNotFound(pluginWorkDirectory: pluginWorkDirectory)
        }
        return sourcePackagesPath
    }
}
