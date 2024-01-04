//
//  _LicenseText.swift
//  SwiftPackageListUI
//
//  Created by Felix Herrmann on 06.03.22.
//

#if canImport(SwiftUI)

import SwiftUI
import SwiftPackageList

internal struct _LicenseText: View {
    internal let _package: Package
    
    internal var body: some View {
        ZStack {
#if os(iOS)
            Color(.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)
#endif
#if os(tvOS)
            _TVOSTextView(_text: _package.license ?? "")
#else
            ScrollView {
                Text(_package.license ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity)
            }
#endif
        }
#if os(visionOS)
        .navigationTitle(Text(_package.name))
        .navigationBarTitleDisplayMode(.inline)
#else
        .backport.navigationTitle(Text(_package.name))
#if os(iOS) || os(watchOS) || os(visionOS)
        .backport.navigationBarTitleDisplayMode(.inline)
#endif
#endif
    }
}

#endif // canImport(SwiftUI)
