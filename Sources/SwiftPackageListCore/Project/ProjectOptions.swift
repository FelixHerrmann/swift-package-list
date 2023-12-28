//
//  ProjectOptions.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 26.12.23.
//

public struct ProjectOptions {
    public var customDerivedDataPath: String?
    public var customSourcePackagesPath: String?
    
    public init(
        customDerivedDataPath: String? = nil,
        customSourcePackagesPath: String? = nil
    ) {
        self.customDerivedDataPath = customDerivedDataPath
        self.customSourcePackagesPath = customSourcePackagesPath
    }
}
