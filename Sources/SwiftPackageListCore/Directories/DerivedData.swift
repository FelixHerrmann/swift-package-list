//
//  DerivedData.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 17.12.23.
//

import Foundation

struct DerivedData: Directory {
    let url: URL
}

extension DerivedData {
    static var defaultDirectory: URL {
        return URL(fileURLWithPath: NSHomeDirectory())
            .appendingPathComponent("Library")
            .appendingPathComponent("Developer")
            .appendingPathComponent("Xcode")
            .appendingPathComponent("DerivedData")
    }
}

extension DerivedData {
    private struct InfoPlist: Decodable {
        let workspacePath: String
        
        enum CodingKeys: String, CodingKey {
            case workspacePath = "WorkspacePath"
        }
    }
    
    func buildDirectory(project: some Project) throws -> URL? {
        let buildDirectories = try FileManager.default.contentsOfDirectory(
            at: url,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        )
        
        for buildDirectory in buildDirectories {
            let buildFiles = try FileManager.default.contentsOfDirectory(
                at: buildDirectory,
                includingPropertiesForKeys: [.isRegularFileKey],
                options: [.skipsHiddenFiles]
            )
            guard let infoPlistFile = buildFiles.first(where: { $0.lastPathComponent == "info.plist" }) else { continue }
            let infoPlistData = try Data(contentsOf: infoPlistFile)
            let infoPlist = try PropertyListDecoder().decode(InfoPlist.self, from: infoPlistData)
            if infoPlist.workspacePath == project.fileURL.path {
                return buildDirectory
            }
        }
        
        return nil
    }
}
