//
//  AcknowledgmentsList.swift
//  SwiftPackageListUI
//
//  Created by Felix Herrmann on 06.03.22.
//

#if canImport(SwiftUI)

import SwiftUI
import OSLog
import SwiftPackageList

/// A `List` that shows all licenses from the package-list file.
///
/// It can be used as the root view in a `NavigationStack`:
/// ```swift
/// var body: some View {
///     NavigationStack {
///         AcknowledgmentsList()
///     }
/// }
/// ```
///
/// It also can be used within a `NavigationLink` to be pushed on the `NavigationStack`:
/// ```swift
/// var body: some View {
///     NavigationStack {
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
/// - Important: This view must be used inside a `NavigationStack` to function properly.
public struct AcknowledgmentsList<Provider: PackageProvider>: View {
    private let _packageProvider: Provider
    @State private var _packages: [Package] = []
    
    /// Creates a ``AcknowledgmentsList`` for a package provider.
    /// - Parameters:
    ///   - packageProvider: The package provider object used as the source of data.
    public init(packageProvider: Provider = .json()) {
        self._packageProvider = packageProvider
    }
    
    public var body: some View {
        List {
            Section(
                header: Text("acknowledgments.section-title", bundle: .module, comment: "Section title for the license list")
            ) {
                ForEach(_packages, id: \.self) { package in
                    NavigationLink(package.name) {
                        _LicenseText(_package: package)
                    }
                }
            }
        }
#if os(visionOS)
        .navigationTitle(
            Text("acknowledgments.title", bundle: .module, comment: "Navigation bar title of the license list")
        )
        .navigationBarTitleDisplayMode(.inline)
        .task {
            _loadPackages()
        }
#else
        .backport.navigationTitle(
            Text("acknowledgments.title", bundle: .module, comment: "Navigation bar title of the license list")
        )
#if os(iOS) || os(watchOS)
        .backport.navigationBarTitleDisplayMode(.inline)
#endif
        .backport.task {
            _loadPackages()
        }
#endif
    }
    
    private func _loadPackages() {
        do {
            _packages = try _packageProvider.packages()
        } catch {
            os_log(
                "Error: %@",
                log: OSLog(subsystem: "com.felixherrmann.swift-package-list", category: "AcknowledgmentsList"),
                type: .error,
                String(describing: error)
            )
        }
    }
}

#endif // canImport(SwiftUI)
