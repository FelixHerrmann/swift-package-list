//
//  SPLAcknowledgmentsTableViewController.swift
//  SwiftPackageListUI
//
//  Created by Felix Herrmann on 26.02.22.
//

#if canImport(UIKit) && !os(watchOS) && !os(tvOS)

import UIKit
import OSLog
import SwiftPackageList

/// A concrete subclass of a table-view controller that shows all licenses from the package-list file.
///
/// All parameters of the table view can be customized to fit the app's appearance, only the used delegate and
/// data-source methods should not be touched.
///
/// - Important: This view controller must be used inside a `UINavigationController` to function properly.
open class SPLAcknowledgmentsTableViewController<T: PackageProvider>: UITableViewController {
    
    // MARK: - Properties
    
    /// The package provider object used as the source of data.
    open var packageProvider: T
    
    /// A boolean value indicating if a bar button item to open the repository is shown.
    ///
    /// Default value of this property is `false`.
    open var canOpenRepositoryLink = false
    
    private var _packages: [Package] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Initializers
    
    /// Initializes a table-view controller with the inset-grouped style for a package provider.
    /// - Parameters:
    ///   - packageProvider: The package provider object used as the source of data.
    public init(packageProvider: T = .json()) {
        self.packageProvider = packageProvider
        super.init(style: .insetGrouped)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        _setupNavigationBar()
        _setupTableView()
        
        do {
            _packages = try packageProvider.packages()
        } catch {
            os_log(
                "Error: %@",
                log: OSLog(
                    subsystem: "com.felixherrmann.swift-package-list",
                    category: "SPLAcknowledgmentsTableViewController"
                ),
                type: .error,
                String(describing: error)
            )
        }
    }
    
    // MARK: - Setup
    
    private func _setupNavigationBar() {
        let title = NSLocalizedString(
            "acknowledgments.title",
            bundle: .module,
            value: "Acknowledgments",
            comment: "Navigation bar title of the license list"
        )
        navigationItem.title = title
    }
    
    private func _setupTableView() {
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.register(_SPLLicenseTableViewCell.self, forCellReuseIdentifier: "licenseCell")
    }
    
    // MARK: - UITableViewDataSource
    
    override open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _packages.count
    }
    
    override open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString(
            "acknowledgments.section-title",
            bundle: .module,
            value: "Licenses",
            comment: "Section title for the license list"
        )
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "licenseCell", for: indexPath)
        cell.textLabel?.text = _packages[indexPath.row].name
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let package = _packages[indexPath.row]
        let licenseTextViewController = _SPLLicenseTextViewController(
            package: package,
            backgroundColor: tableView.backgroundColor ?? .white,
            canOpenRepositoryLink: canOpenRepositoryLink
        )
        navigationController?.pushViewController(licenseTextViewController, animated: true)
    }
}

#endif // canImport(UIKit) && !os(watchOS) && !os(tvOS)
