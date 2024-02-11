//
//  Bundle+acknowledgements.swift
//  SwiftPackageList
//
//  Created by Felix Herrmann on 11.02.24.
//

import Foundation

extension Bundle {
    /// The file URL of the 'Acknowledgements.pdf' file.
    public var acknowledgementsURL: URL? {
        return url(forResource: "Acknowledgements", withExtension: "pdf")
    }
    
    /// The full pathname of the 'Acknowledgements.pdf' file.
    public var acknowledgementsPath: String? {
        return path(forResource: "Acknowledgements", ofType: "pdf")
    }
}
