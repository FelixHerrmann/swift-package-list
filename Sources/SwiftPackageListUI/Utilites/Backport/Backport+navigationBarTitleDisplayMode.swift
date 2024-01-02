//
//  Backport+navigationBarTitleDisplayMode.swift
//  SwiftPackageListUI
//
//  Created by Felix Herrmann on 02.01.24.
//

import SwiftUI

@available(iOS, deprecated: 14.0, message: "Back-port no longer needed with iOS 14")
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, deprecated: 8.0, message: "Back-port no longer needed with watchOS 8")
@available(visionOS, deprecated: 1.0, message: "Back-port no longer needed with visionOS 1")
internal struct NavigationBarTitleDisplayModeModifier: ViewModifier {
    internal enum TitleDisplayMode {
        case automatic
        case inline
        case large
        
        @available(iOS 14.0, watchOS 8.0, visionOS 1.0, *)
        internal var displayMode: NavigationBarItem.TitleDisplayMode {
            switch self {
            case .automatic:
                return .automatic
            case.inline:
                return .inline
            case .large:
                return .large
            }
        }
    }
    
    internal let displayMode: TitleDisplayMode
    
    internal func body(content: Content) -> some View {
        if #available(iOS 14.0, macOS 11.0, watchOS 8.0, visionOS 1.0, *) {
            content.navigationBarTitleDisplayMode(displayMode.displayMode)
        } else {
            content
        }
    }
}

extension Backport where Content: View {
    @available(iOS, deprecated: 14.0, message: "Back-port no longer needed with iOS 14")
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, deprecated: 8.0, message: "Back-port no longer needed with watchOS 8")
    @available(visionOS, deprecated: 1.0, message: "Back-port no longer needed with visionOS 1")
    internal func navigationBarTitleDisplayMode(
        _ displayMode: NavigationBarTitleDisplayModeModifier.TitleDisplayMode
    ) -> some View {
        content.modifier(NavigationBarTitleDisplayModeModifier(displayMode: displayMode))
    }
}
