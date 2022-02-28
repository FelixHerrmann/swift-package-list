//
//  _SPLLicenseTextViewController.swift
//  SwiftPackageListUI
//
//  Created by Felix Herrmann on 26.02.22.
//

#if canImport(UIKit)

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
    
    init(package: Package, backgroundColor: UIColor, canOpenRepositoryLink: Bool) {
        self._package = package
        self._backgroundColor = backgroundColor
        self._canOpenRepositoryLink = canOpenRepositoryLink
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - ViewController
    
    override func loadView() {
        view = _textView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _setupNavigationBar()
        _setupTextView()
    }
    
    @available(iOS 11.0, *)
    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        
        let horizontalInset = _textView.readableContentGuide.layoutFrame.origin.x
        _textView.textContainerInset = UIEdgeInsets(top: 20, left: horizontalInset, bottom: 20, right: horizontalInset)
    }
    
    
    // MARK: - Setup
    
    private func _setupNavigationBar() {
        navigationItem.title = _package.name
        
        if _canOpenRepositoryLink {
            let repositoryBarButtonItem: UIBarButtonItem
            if #available(iOS 13.0, *) {
                let image = UIImage(systemName: "safari")
                repositoryBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(_handleRepositoryBarButtonItemPress))
            } else {
                let title = NSLocalizedString("license-text.repository-button-text", bundle: .module, value: "Repository", comment: "Opens the repository in a browser window, only shown on iOS 12 and lower")
            repositoryBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(_handleRepositoryBarButtonItemPress))
            }
            navigationItem.rightBarButtonItem = repositoryBarButtonItem
        }
    }
    
    private func _setupTextView() {
        _textView.backgroundColor = _backgroundColor
        _textView.font = .preferredFont(forTextStyle: .caption1)
        if #available(iOS 13.0, *) {
            _textView.textColor = .secondaryLabel
        } else {
            _textView.textColor = UIColor(red: 60 / 255, green: 60/255, blue: 67/255, alpha: 0.6)
        }
        _textView.alwaysBounceVertical = true
        _textView.isEditable = false
        _textView.text = _package.license
        _textView.preservesSuperviewLayoutMargins = true
    }
    
    
    // MARK: - Selector Methods
    
    @objc private func _handleRepositoryBarButtonItemPress() {
        _openRepositoryLink()
    }
    
    
    // MARK: - Methods
    
    private func _openRepositoryLink() {
        let safariViewController = SFSafariViewController(url: _package.repositoryURL)
        present(safariViewController, animated: true)
    }
}

#endif // canImport(UIKit)
