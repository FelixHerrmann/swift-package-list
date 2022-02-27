//
//  SPLAcknowledgmentsTableViewController.swift
//  SwiftPackageList
//
//  Created by Felix Herrmann on 26.02.22.
//

#if canImport(UIKit)

import UIKit
import OSLog

/// A concrete subclass of a table-view controller that shows all licenses from the `package-list.json` or `package-list.plist` file in the specified bundle.
///
/// All parameters of the table view can be customized to fit the app's appearance, only the used delegate and data-source methods should not be touched.
///
/// - Important: This view controller must be used inside a `UINavigationController` to function properly.
open class SPLAcknowledgmentsTableViewController: UITableViewController {
    
    
    // MARK: - Properties
    
    /// A boolean value indicating if a bar button item to open the repository is shown.
    ///
    /// Default value of this property is `false`.
    open var canOpenRepositoryLink: Bool = false
    
    /// The bundle where the `package-list.json` or `package-list.plist` file is stored.
    ///
    /// Default value of this property is `Bundle.main`.
    open var packageListBundle: Bundle = .main
    
    private var _packages: [Package] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    // MARK: - Initializers
    
    /// Initializes a table-view controller with the default style for a license list.
    ///
    /// It is `UITableView.Style.insetGrouped` on iOS 13+ and `UITableView.Style.grouped` for older OS versions.
    public convenience init() {
        if #available(iOS 13.0, *) {
            self.init(style: .insetGrouped)
        } else {
            self.init(style: .grouped)
        }
    }
    
    
    // MARK: - ViewController
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        _setupNavigationBar()
        _setupTableView()
        
        do {
            _packages = try packageList(bundle: packageListBundle)
        } catch {
            if #available(iOS 10.0, *) {
                os_log("Error: %@", log: OSLog(subsystem: "com.felixherrmann.swift-package-list", category: "SPLAcknowledgmentsTableViewController"), type: .error, String(describing: error))
            } else {
                NSLog("Error: %@", String(describing: error))
            }
        }
    }
    
    
    // MARK: - Setup
    
    private func _setupNavigationBar() {
        let title = NSLocalizedString("acknowledgments.title", bundle: .module, value: "Acknowledgments", comment: "Navigation bar title of the license list")
        navigationItem.title = title
    }
    
    private func _setupTableView() {
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.register(_SPLLicenseTableViewCell.self, forCellReuseIdentifier: "licenseCell")
    }
}


// MARK: - UITableViewDataSource

extension SPLAcknowledgmentsTableViewController {
    
    open override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _packages.count
    }
    
    open override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("acknowledgments.section-title", bundle: .module, value: "Licenses", comment: "Section title for the license list")
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "licenseCell", for: indexPath) as? _SPLLicenseTableViewCell else {
            return UITableViewCell()
        }
        cell.textLabel?.text = _packages[indexPath.row].name
        return cell
    }
}


// MARK: - UITableViewDelegate

extension SPLAcknowledgmentsTableViewController {
    
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let package = _packages[indexPath.row]
        let licenseTextViewController = _SPLLicenseTextViewController(package: package, backgroundColor: tableView.backgroundColor ?? .white, canOpenRepositoryLink: canOpenRepositoryLink)
        navigationController?.pushViewController(licenseTextViewController, animated: true)
    }
}

#endif // canImport(UIKit)
