//
//  Backport+task.swift
//  SwiftPackageListUI
//
//  Created by Felix Herrmann on 02.01.24.
//

import SwiftUI

@available(iOS, deprecated: 15.0, message: "Back-port no longer needed with iOS 15")
@available(macOS, deprecated: 12.0, message: "Back-port no longer needed with macOS 12")
@available(tvOS, deprecated: 15.0, message: "Back-port no longer needed with tvOS 15")
@available(watchOS, deprecated: 8.0, message: "Back-port no longer needed with watchOS 8")
@available(visionOS, deprecated: 1.0, message: "Back-port no longer needed with visionOS 1")
internal struct TaskModifier: ViewModifier {
    internal let priority: TaskPriority
    internal let action: @Sendable () async -> Void
    
    @State private var currentTask: Task<Void, Never>?
    
    internal func body(content: Content) -> some View {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *) {
            content.task(priority: priority, action)
        } else {
            content
                .onAppear {
                    currentTask = Task(priority: priority, operation: action)
                }
                .onDisappear {
                    currentTask?.cancel()
                }
        }
    }
}

extension Backport where Content: View {
    @available(iOS, deprecated: 15.0, message: "Back-port no longer needed with iOS 15")
    @available(macOS, deprecated: 12.0, message: "Back-port no longer needed with macOS 12")
    @available(tvOS, deprecated: 15.0, message: "Back-port no longer needed with tvOS 15")
    @available(watchOS, deprecated: 8.0, message: "Back-port no longer needed with watchOS 8")
    @available(visionOS, deprecated: 1.0, message: "Back-port no longer needed with visionOS 1")
    internal func task(
        priority: TaskPriority = .userInitiated,
        @_inheritActorContext _ action: @escaping @Sendable () async -> Void
    ) -> some View {
        content.modifier(TaskModifier(priority: priority, action: action))
    }
}
