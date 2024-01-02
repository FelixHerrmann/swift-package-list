//
//  _AcknowledgmentsListViewModel.swift
//  SwiftPackageListUI
//
//  Created by Felix Herrmann on 06.03.22.
//

import Foundation
import os.log
import SwiftPackageList

internal final class _AcknowledgmentsListViewModel: ObservableObject {
    @Published internal var _packages: [Package] = []
    
    internal init(packageListBundle: Bundle, packageListFileName: String) {
        do {
            _packages = try packageList(bundle: packageListBundle, fileName: packageListFileName)
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
