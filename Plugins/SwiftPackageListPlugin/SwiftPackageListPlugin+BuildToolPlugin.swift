//
//  SwiftPackageListPlugin+BuildToolPlugin.swift
//  SwiftPackageListPlugin
//
//  Created by Felix Herrmann on 03.02.24.
//

import PackagePlugin

extension SwiftPackageListPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        let executable = try context.tool(named: "swift-package-list").path
        
        let configurationPath = context.package.directory.appending(Configuration.fileName)
        let configuration = try Configuration(path: configurationPath)
        let targetConfiguration = configuration?.targets?[target.name] ?? configuration?.project
        
        let relativeProjectPath = configuration?.projectPath ?? "Package.swift"
        let projectPath = context.package.directory.appending(relativeProjectPath)
        
        return try createBuildCommands(
            executable: executable,
            targetConfiguration: targetConfiguration,
            projectPath: projectPath,
            pluginWorkDirectory: context.pluginWorkDirectory
        )
    }
}
