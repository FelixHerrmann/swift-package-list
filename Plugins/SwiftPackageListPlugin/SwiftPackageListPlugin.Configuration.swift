//
//  SwiftPackageListPlugin.Configuration.swift
//  SwiftPackageListPlugin
//
//  Created by Felix Herrmann on 03.02.24.
//

import Foundation
import PackagePlugin

extension SwiftPackageListPlugin {
    struct Configuration: Decodable {
        let projectPath: String?
        let project: TargetConfiguration?
        let targets: [String: TargetConfiguration]? // swiftlint:disable:this discouraged_optional_collection
    }
}

extension SwiftPackageListPlugin.Configuration {
    struct TargetConfiguration: Decodable {
        let outputType: OutputType?
        let requiresLicense: Bool? // swiftlint:disable:this discouraged_optional_boolean
    }
}

extension SwiftPackageListPlugin.Configuration {
    enum OutputType: String, Decodable {
        case stdout
        case json
        case plist
        case settingsBundle = "settings-bundle"
        case pdf
    }
}

extension SwiftPackageListPlugin.Configuration.OutputType {
    var fileName: String? {
        switch self {
        case .stdout:
            return nil
        case .json:
            return "package-list.json"
        case .plist:
            return "package-list.plist"
        case .settingsBundle:
            return "Settings.bundle"
        case .pdf:
            return "Acknowledgements.pdf"
        }
    }
}

extension SwiftPackageListPlugin.Configuration {
    static let fileName = "swift-package-list-config.json"
}

extension SwiftPackageListPlugin.Configuration {
    init?(path: Path) throws {
        guard FileManager.default.fileExists(atPath: path.string) else { return nil }
        let url = URL(filePath: path.string)
        
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw SwiftPackageListPlugin.Error.configurationUnavailable(path: path, underlyingError: error)
        }
        
        let decoder = JSONDecoder()
        do {
            self = try decoder.decode(SwiftPackageListPlugin.Configuration.self, from: data)
        } catch {
            throw SwiftPackageListPlugin.Error.configurationInvalid(path: path, underlyingError: error)
        }
    }
}
