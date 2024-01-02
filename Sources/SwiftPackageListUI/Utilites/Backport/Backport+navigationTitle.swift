//
//  Backport+navigationTitle.swift
//  SwiftPackageListUI
//
//  Created by Felix Herrmann on 02.01.24.
//

import SwiftUI

@available(iOS, deprecated: 14.0, message: "Back-port no longer needed with iOS 14")
@available(macOS, deprecated: 11.0, message: "Back-port no longer needed with macOS 11")
@available(tvOS, deprecated: 14.0, message: "Back-port no longer needed with tvOS 14")
@available(watchOS, deprecated: 7.0, message: "Back-port no longer needed with watchOS 7")
@available(visionOS, deprecated: 1.0, message: "Back-port no longer needed with visionOS 1")
internal struct NavigationTitleModifier: ViewModifier {
    internal let title: Text
    
    internal func body(content: Content) -> some View {
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, visionOS 1.0, *) {
            content.navigationTitle(title)
        } else {
#if os(macOS)
            content
#else
            content.navigationBarTitle(title)
#endif
        }
    }
}
extension Backport where Content: View {
    @available(iOS, deprecated: 14.0, message: "Back-port no longer needed with iOS 14")
    @available(macOS, deprecated: 11.0, message: "Back-port no longer needed with macOS 11")
    @available(tvOS, deprecated: 14.0, message: "Back-port no longer needed with tvOS 14")
    @available(watchOS, deprecated: 7.0, message: "Back-port no longer needed with watchOS 7")
    @available(visionOS, deprecated: 1.0, message: "Back-port no longer needed with visionOS 1")
    internal func navigationTitle(_ title: Text) -> some View {
        content.modifier(NavigationTitleModifier(title: title))
    }
}
