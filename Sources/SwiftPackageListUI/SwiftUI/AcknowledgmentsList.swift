//
//  AcknowledgmentsList.swift
//  SwiftPackageListUI
//
//  Created by Felix Herrmann on 06.03.22.
//

#if canImport(SwiftUI)

import SwiftUI

/// A `List` that shows all licenses from the package-list file.
///
/// It can be used as the root view in a `NavigationView`:
/// ```swift
/// var body: some View {
///     NavigationView {
///         AcknowledgmentsList()
///     }
/// }
/// ```
///
/// It also can be used within a `NavigationLink` to be pushed on the `NavigationView`:
/// ```swift
/// var body: some View {
///     NavigationView {
///         List {
///             NavigationLink("Acknowledgments") {
///                 AcknowledgmentsList()
///             }
///         }
///         .navigationTitle("Example")
///     }
/// }
/// ```
///
/// - Important: This view must be used inside a `NavigationView` to function properly.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct AcknowledgmentsList: View {
    
    @ObservedObject
    private var _viewModel: _AcknowledgmentsListViewModel
    
    /// Creates a ``AcknowledgmentsList`` for a package-list file.
    /// - Parameters:
    ///   - packageListBundle: The bundle where the package-list file is stored. Default's to `Bundle.main`.
    ///   - packageListFileName: The name of the package-list file. Default's to `package-list`.
    public init(packageListBundle: Bundle = .main, packageListFileName: String = "package-list") {
        _viewModel = _AcknowledgmentsListViewModel(packageListBundle: packageListBundle, packageListFileName: packageListFileName)
    }
    
    public var body: some View {
        List {
            Section(header: Text("acknowledgments.section-title", bundle: .module, comment: "Section title for the license list")) {
                ForEach(_viewModel._packages, id: \.self) { package in
                    NavigationLink(package.name) {
                        _LicenseText(_package: package)
                    }
                }
            }
        }
        ._navigationTitle(Text("acknowledgments.title", bundle: .module, comment: "Navigation bar title of the license list"))
    }
}

#endif // canImport(SwiftUI)
