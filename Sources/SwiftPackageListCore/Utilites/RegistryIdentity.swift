//
//  RegistryIdentity.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 02.03.25.
//

struct RegistryIdentity {
    let scope: String
    let name: String
}

extension RegistryIdentity {
    init?(identity: String) {
        let components = identity.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: true)
        guard components.count == 2 else { return nil }
        self.init(
            scope: String(components[0]),
            name: String(components[1])
        )
    }
}
