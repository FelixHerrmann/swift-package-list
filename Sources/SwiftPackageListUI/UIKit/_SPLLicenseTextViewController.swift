//
//  _SPLLicenseTextViewController.swift
//  SwiftPackageListUI
//
//  Created by Felix Herrmann on 26.02.22.
//

#if canImport(UIKit) && !os(watchOS) && !os(tvOS)

import UIKit
import SafariServices
import SwiftPackageList

internal final class _SPLLicenseTextViewController: UIViewController {
    
    // MARK: - Properties
    
    private let _package: Package
    private let _backgroundColor: UIColor
    private let _canOpenRepositoryLink: Bool
    
    private let _textView = UITextView()
    
    // MARK: - Initializers
    
    internal init(package: Package, backgroundColor: UIColor, canOpenRepositoryLink: Bool) {
        self._package = package
        self._backgroundColor = backgroundColor
        self._canOpenRepositoryLink = canOpenRepositoryLink
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController
    
    override internal func loadView() {
        view = _textView
    }
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        _setupNavigationBar()
        _setupTextView()
    }
    
    override internal func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        
        let horizontalInset = _textView.readableContentGuide.layoutFrame.origin.x
        _textView.textContainerInset = UIEdgeInsets(top: 20, left: horizontalInset, bottom: 20, right: horizontalInset)
    }
    
    // MARK: - Setup
    
    private func _setupNavigationBar() {
        navigationItem.title = _package.name
        
        if _canOpenRepositoryLink {
            let repositoryBarButtonItem: UIBarButtonItem
            let image = UIImage(systemName: "safari")
            repositoryBarButtonItem = UIBarButtonItem(
                image: image,
                style: .plain,
                target: self,
                action: #selector(_handleRepositoryBarButtonItemPress)
            )
            navigationItem.rightBarButtonItem = repositoryBarButtonItem
        }
    }
    
    private func _setupTextView() {
        _textView.backgroundColor = _backgroundColor
        _textView.font = .preferredFont(forTextStyle: .caption1)
        _textView.textColor = .secondaryLabel
        _textView.alwaysBounceVertical = true
        _textView.isEditable = false
        _textView.text = _package.license
        _textView.preservesSuperviewLayoutMargins = true
    }
    
    // MARK: - Selector Methods
    
    @objc
    private func _handleRepositoryBarButtonItemPress() {
        _openRepositoryLink()
    }
    
    // MARK: - Methods
    
    private func _openRepositoryLink() {
        let safariViewController = SFSafariViewController(url: _package.repositoryURL)
        present(safariViewController, animated: true)
    }
}

#endif // canImport(UIKit) && !os(watchOS) && !os(tvOS)
