//
//  _AcknowledgmentsListViewModel.swift
//  SwiftPackageListUI
//
//  Created by Felix Herrmann on 06.03.22.
//

import Foundation
import os.log
import SwiftPackageList

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
internal final class _AcknowledgmentsListViewModel: ObservableObject {
    
    @Published
    internal var _packages: [Package] = []
    
    internal init(packageListBundle: Bundle, packageListFileName: String) {
        do {
            _packages = try packageList(bundle: packageListBundle, fileName: packageListFileName)
        } catch {
            os_log("Error: %@", log: OSLog(subsystem: "com.felixherrmann.swift-package-list", category: "SPLAcknowledgmentsTableViewController"), type: .error, String(describing: error))
        }
    }
}
