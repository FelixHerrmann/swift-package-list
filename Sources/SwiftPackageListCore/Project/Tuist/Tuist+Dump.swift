//
//  Tuist+Dump.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 31.12.23.
//

import Foundation

extension Tuist {
    struct Dump: Decodable {
        let name: String
        let organizationName: String?
    }
}

extension Tuist {
    static func createDump(fileURL: URL) throws -> Dump {
        let data: Data
        do {
            let path = fileURL.deletingLastPathComponent().path
            data = try zsh("tuist dump --path \(path)").output
        } catch {
            throw RuntimeError("Executing 'tuist dump' failed: \(String(describing: error))")
        }
        
        do {
            let decoder = JSONDecoder()
            let dump = try decoder.decode(Dump.self, from: data)
            return dump
        } catch {
            let output = String(decoding: data, as: UTF8.self)
            throw RuntimeError("'tuist dump' failed failed with the following output: \(output)")
        }
    }
}
