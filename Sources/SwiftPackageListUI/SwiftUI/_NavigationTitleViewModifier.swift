//
//  _NavigationTitleViewModifier.swift
//  SwiftPackageListUI
//
//  Created by Felix Herrmann on 06.03.22.
//

#if canImport(SwiftUI)

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, visionOS 1.0, *)
internal struct _NavigationTitleViewModifier: ViewModifier {
    internal var _title: Text
    
    internal func body(content: Content) -> some View {
        #if os(macOS) || os(tvOS)
        content
            .navigationTitle(_title)
        #elseif os(watchOS)
        if #available(watchOS 8.0, *) {
            content
                .navigationTitle(_title)
                .navigationBarTitleDisplayMode(.inline)
        } else {
            content
                .navigationTitle(_title)
        }
        #else
        content
            .navigationTitle(_title)
            .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

@available(iOS, introduced: 13.0, deprecated: 14.0, message: "Use _NavigationTitleViewModifier instead")
@available(macOS, introduced: 10.15, deprecated: 11.0, message: "Use _NavigationTitleViewModifier instead")
@available(tvOS, introduced: 13.0, deprecated: 14.0, message: "Use _NavigationTitleViewModifier instead")
@available(watchOS, introduced: 6.0, deprecated: 7.0, message: "Use _NavigationTitleViewModifier instead")
@available(visionOS, deprecated, message: "Use _NavigationTitleViewModifier instead")
internal struct _NavigationBarTitleViewModifier: ViewModifier {
    internal var _title: Text
    
    internal func body(content: Content) -> some View {
        #if os(macOS) || os(watchOS) || os(tvOS)
        content
        #else
        content
            .navigationBarTitle(_title, displayMode: .inline)
        #endif
    }
}

extension View {
    @ViewBuilder
    internal func _navigationTitle(_ title: Text) -> some View {
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, visionOS 1.0, *) {
            modifier(_NavigationTitleViewModifier(_title: title))
        } else {
            modifier(_NavigationBarTitleViewModifier(_title: title))
        }
    }
}

#endif // canImport(SwiftUI)
