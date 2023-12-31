//
//  ZSH.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 31.12.23.
//

import Foundation

@discardableResult
func zsh(_ command: String) throws -> Data {
    let task = Process()
    let pipe = Pipe()
    
    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-l", "-c", command]
    task.executableURL = URL(fileURLWithPath: "/bin/zsh")
    task.standardInput = nil
    
    try task.run()
    task.waitUntilExit()
    
    return pipe.fileHandleForReading.readDataToEndOfFile()
}
