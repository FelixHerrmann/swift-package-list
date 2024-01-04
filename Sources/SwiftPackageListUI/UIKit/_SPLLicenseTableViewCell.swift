//
//  _SPLLicenseTableViewCell.swift
//  SwiftPackageListUI
//
//  Created by Felix Herrmann on 26.02.22.
//

#if canImport(UIKit) && !os(watchOS) && !os(tvOS)

import UIKit

internal final class _SPLLicenseTableViewCell: UITableViewCell {
    override internal init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
    }
    
    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#endif // canImport(UIKit) && !os(watchOS)
