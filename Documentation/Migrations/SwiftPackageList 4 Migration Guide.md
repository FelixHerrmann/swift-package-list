#  SwiftPackageList 4 Migration Guide

This guide eases the transition of the existing apps that use SwiftPackageList 3.x to the
latest version of the tool.

### Minimum Requirements

```diff
- Swift 5.7
+ Swift 5.9

  macOS 10.15
  Mac Catalyst 13.0
  iOS 13.0
  tvOS 13.0
  watchOS 6.0
+ visionOS 1.0
```

## `generate`/`scan` Subcommands and `stdout` Output Type

The `generate` and `scan` command got merged together. This means there is no need for a
dedicated subcommand anymore and the CLI interface works like before the `scan` command
introduction:

```shell
// SwiftPackageList 3
swift-package-list generate Test.xcodeproj 

// SwiftPackageList 4
swift-package-list Test.xcodeproj --output-type json
```

To provide the existing functionality from the `scan` command there is a new `stdout`
output-type which will print the output in JSON format to the console: 

```shell
// SwiftPackageList 3
swift-package-list scan Test.xcodeproj 

// SwiftPackageList 4
swift-package-list Test.xcodeproj --output-type stdout
```
> [!IMPORTANT]
> `stdout` is now the default option so it is necessary to specify `--output-type json`
> for existing setups.

## `Package.name` and `Package.identity`

The behavior of the `name` field has changed, it will now use the name defined in the
Package.swift manifest instead of constructing it from the repository URL. This means that
the name is no longer guaranteed to be unique and should not be used for identification
purposes; to offer and alternative there is a new `identity` field, exposed from SPM:

```json
// SwiftPackageList 3
[
  {
    "license" : "...",
    "name" : "swift-package-manager",
    "repositoryURL" : "https:\/\/github.com\/apple\/swift-package-manager",
    "revision" : "f5ea3972d7d6c574e8bb16a19b2a7bca98ea131b",
    "version" : "0.6.0"
  }
]

// SwiftPackageList 4
[
  {
    "identity" : "swift-package-manager",
    "license" : "...",
    "name" : "SwiftPM",
    "repositoryURL" : "https:\/\/github.com\/apple\/swift-package-manager",
    "revision" : "f5ea3972d7d6c574e8bb16a19b2a7bca98ea131b",
    "version" : "0.6.0"
  }
]
```

## `packageList()` and `PackageProvider`

The top-level `packageList()` function in the `SwiftPackageList` module got removed in
favor of a `PackageProvider` protocol with dedicated implementations for JSON and
Property-Lists:

```swift
// SwiftPackageList 3
let packages = try packageList(bundle: .main, fileName: "package-list")

// SwiftPackageList 4
let packageProvider = JSONPackageProvider(bundle: .main, fileName: "package-list")
let packages = try packageProvider.packages()
```

This new protocol is also used in the `SwiftPackageListUI` module to provide the same
level of flexibility from this new approach:

```swift
// SwiftPackageList 3
var body: some View {
    AcknowledgmentsList(packageListBundle: .main, packageListFileName: "package-list")
}

// SwiftPackageList 4
var body: some View {
    AcknowledgmentsList(packageProvider: .json(bundle: .main, fileName: "package-list"))
}
```

## Swift Package Plugins and `swift-package-list-config.json`

The `SwiftPackageListJSONPlugin`, `SwiftPackageListPropertyListPlugin`,
`SwiftPackageListPDFPlugin` and `SwiftPackageListSettingsBundlePlugin` got replaced by a
single `SwiftPackageListPlugin`. Open the target's **Build Phase** section, remove the
existing plugin from the **Run Build Tool Plug-ins** section and add the
`SwiftPackageListPlugin`:

<img width="937" alt="Screenshot 2024-02-11 at 20 13 43" src="https://github.com/FelixHerrmann/swift-package-list/assets/42500484/21772537-4800-4654-9e4e-5efc736f4025">
<img width="938" alt="Screenshot 2024-02-11 at 20 07 07" src="https://github.com/FelixHerrmann/swift-package-list/assets/42500484/d265efac-bf1c-4965-b240-876ea0131608">


By default this new plugin will use the JSON output-type. To configure this, create a
`swift-package-list-config.json` in the project's root with the following format:

```json
{
    "project" : {
        "outputType" : "pdf"
    }
}
```

## Objective-C Support Removed

The `SwiftPackageListObjc` module got removed without a replacement.

`SPLAcknowledgmentsTableViewController` is also no longer exposed to the Objective-C
runtime due to its added generic constraint.
