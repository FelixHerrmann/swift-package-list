//
//  Backport.swift
//  SwiftPackageListUI
//
//  Created by Felix Herrmann on 02.01.24.
//

import SwiftUI

internal struct Backport<Content> {
    internal let content: Content
    
    internal init(_ content: Content) {
        self.content = content
    }
}

extension View {
    internal var backport: Backport<Self> {
        Backport(self)
    }
}
