//
//  SwiftPackageListPlugin+XcodeBuildToolPlugin.swift
//  SwiftPackageListPlugin
//
//  Created by Felix Herrmann on 03.02.24.
//

#if canImport(XcodeProjectPlugin)
import PackagePlugin
import XcodeProjectPlugin

extension SwiftPackageListPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let executable = try context.tool(named: "swift-package-list").path
        
        let configurationPath = context.xcodeProject.directory.appending(Configuration.fileName)
        let configuration = try Configuration(path: configurationPath)
        let targetConfiguration = configuration?.targets?[target.displayName] ?? configuration?.project
        
        let relativeProjectPath = configuration?.projectPath ?? "\(context.xcodeProject.displayName).xcodeproj"
        let projectPath = context.xcodeProject.directory.appending(relativeProjectPath)
        
        return try createBuildCommands(
            executable: executable,
            targetConfiguration: targetConfiguration,
            projectPath: projectPath,
            pluginWorkDirectory: context.pluginWorkDirectory
        )
    }
}
#endif
