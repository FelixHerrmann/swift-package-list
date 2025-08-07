# SwiftPackageList

[![Xcode Build](https://github.com/FelixHerrmann/swift-package-list/actions/workflows/xcodebuild.yml/badge.svg)](https://github.com/FelixHerrmann/swift-package-list/actions/workflows/xcodebuild.yml)
[![SwiftLint](https://github.com/FelixHerrmann/swift-package-list/actions/workflows/swiftlint.yml/badge.svg)](https://github.com/FelixHerrmann/swift-package-list/actions/workflows/swiftlint.yml)

A command-line tool to get all used Swift Package dependencies.

The output includes all the `Package.resolved` informations and the license from the checkouts.
You can also generate a JSON, PLIST, Settings.bundle or PDF file.

Additionally there is a Swift Package to read the generated package-list file from the application's bundle or to use pre-build UI for SwiftUI and UIKit.


## Command-Line Tool

### Installation

#### Using [Homebrew](https://brew.sh)

```shell
brew tap FelixHerrmann/tap
brew install swift-package-list
```

#### Using [Mint](https://github.com/yonaskolb/mint):

```shell
mint install FelixHerrmann/swift-package-list
```

#### Installing from source:

Clone or download this repository and run `make install`, `make update` or `make uninstall`.

### Usage

Open the terminal and run `swift-package-list <project-path>` with the path to the project file you want to generate the list from.
Currently supported are:
- `*.xcodeproj` for Xcode projects
- `*.xcworkspace` for Xcode workspaces
- `Package.swift` for Swift packages
- `Project.swift` for Tuist projects
- Tuist with [external dependencies](https://docs.tuist.dev/en/guides/features/projects/dependencies#external-dependencies)
    - Tuist 4.x: `swift-package-list Package.swift --custom-source-packages-path .build` (in the `Tuist` folder)
    - Tuist 3.x: `swift-package-list Dependencies.swift` 

In addition to that you can specify the following options:

| Option                                                        | Description                                                                                                                     |
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| --custom-derived-data-path \<custom-derived-data-path\>       | A custom path to your DerivedData-folder.                                                                                       |
| --custom-source-packages-path \<custom-source-packages-path\> | A custom path to the SourcePackages-folder.                                                                                     |
| --custom-packages-file-path \<custom-packages-file-path\>     | A path to a file containing custom packages in the same format as the JSON-output. (This option may be repeated multiple times) |
| --output-type \<output-type\>                                 | The type of output for the package-list. (values: stdout, json, plist, settings-bundle, pdf; default: stdout)                   |
| --output-path \<output-path\>                                 | The path where the package-list file will be stored. (Not required for stdout output-type)                                      |
| --custom-file-name \<custom-file-name\>                       | A custom filename to be used instead of the default ones.                                                                       |
| --requires-license                                            | Will skip the packages without a license-file.                                                                                  |
| --ignore-package \<package-identity\>                         | Will skip a package with the specified identity. (This option may be repeated multiple times)                                   |
| --version                                                     | Show the version.                                                                                                               |
| -h, --help                                                    | Show help information.                                                                                                          |

### Build Tool Plugin

The easiest way to add this tool to your project is using the provided build-tool plugin, available for both Xcode projects and Swift packages.

For Xcode projects simply add it under the `Run Build Tool Plug-ins` section in the Target's Build Phases tab after you have added this package to the project's Package Dependencies; for Swift packages configure it in the `Package.swift` manifest, as described [here](https://github.com/apple/swift-package-manager/blob/main/Documentation/Plugins.md#using-a-package-plugin).

By default this will use the JSON output with `--requires-license` but you can create a `swift-package-list-config.json` in your project's root to configure that behavior, both project and target specific (target configs have precedence over the project one). Everything in the configuration is optional and has the following format:
```json5
// SwiftPackageList configuration file
// Check out https://github.com/FelixHerrmann/swift-package-list#build-tool-plugin for all possible configuration options.

{
    projectPath: "Project.xcworkspace",
    project: {
        outputType: "plist",
        requiresLicense: false,
    },
    targets: {
        "Target 1": {
            outputType: "settings-bundle",
            requiresLicense: true,
        },
        "Target 2": {
            outputType: "json",
            requiresLicense: true,
            ignorePackages: [
                "swift-package-list",
                "swift-argument-parser",
            ],
            customPackagesFilePaths: [
                "custom-packages.json",
            ],
        },
    },
}
```

Once added and configured the file(s) will get generated during every build process and are available in the App's bundle.
You can then open them manually or use the various options in the included [Swift Package](#swift-package).

> [!NOTE]
> When using Xcode Cloud add `defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES`
> to `ci_post_clone.sh` which disables the plugin validation.

### Run Script Phase

You can easily set up a Run Script Phase in your target of your Xcode project to keep the package-list file up to date automatically:

1. open the corresponding target and click on the plus under the *Build Phases* section
2. select *New Run Script Phase* and add the following script into the code box:
```shell
if command -v swift-package-list &> /dev/null; then
    OUTPUT_PATH=$SOURCE_ROOT/$TARGETNAME
    swift-package-list "$PROJECT_FILE_PATH" --output-type json --output-path "$OUTPUT_PATH" --requires-license
else
    echo "warning: swift-package-list not installed"
fi
```
3. move the Phase above the `Copy Bundle Resources`-phase
4. optionally you can rename the Phase by double-clicking on the title
5. build your project (<kbd>cmd</kbd> + <kbd>b</kbd>)
6. right-click on the targets-folder in the sidebar and select *Add Files to "\<project-name\>"*
7. select `package-list.json` in the Finder-window

The package-list file will be updated now on every build and can be opened from the bundle in your app.
You can do that manually or use the [Swift Package](#swift-package) for that.

#### Xcode Workspace (CocoaPods)

If you have an Xcode workspace instead of a standard Xcode project everything works exactly the same,
you just need a slightly modified script for the Run Script Phase:
```shell
if command -v swift-package-list &> /dev/null; then
    OUTPUT_PATH=$SOURCE_ROOT/$TARGETNAME
    WORKSPACE_FILE_PATH=${PROJECT_FILE_PATH%.xcodeproj}.xcworkspace
    swift-package-list "$WORKSPACE_FILE_PATH" --output-type json --output-path "$OUTPUT_PATH" --requires-license
else
    echo "warning: swift-package-list not installed"
fi
```

#### Homebrew Troubleshooting on Apple Silicon

If you used Homebrew to install the Command-Line Tool on an Apple Silicon Mac, Xcode will not recognize the swift-package-list command.
This is because Homebrew uses it's own /bin directory and Xcode's PATH environment variable is not aware of that.
There are 2 easy ways to fix this issue:

- add `export PATH="$PATH:/opt/homebrew/bin"` as the first line to your build script
- execute `ln -s /opt/homebrew/bin/swift-package-list /usr/local/bin/swift-package-list` in your Terminal

#### Mint Troubleshooting

If you used Mint to install the Command-Line Tool, Xcode will not recognize the swift-package-list command.
This is because Mint uses it's own /bin directory and Xcode's PATH environment variable is not aware of that.
There are 2 easy ways to fix this issue:

- add `export PATH="$PATH:$HOME/.mint/bin/"` as the first line to your build script
- execute `ln -s $HOME/.mint/bin/swift-package-list /usr/local/bin/swift-package-list` in your Terminal

### Settings Bundle

You can also generate a `Settings.bundle` file to show the acknowledgements in the Settings app. This works slightly different
than the other file types, because a Settings Bundle is a collection of several files and might already exist in your app. 
Just specify `--output-type settings-bundle` on the command execution.

**Important:** The `Root.plist` and `Root.strings` files will (unlike the other files) only be created if they not already exists,
otherwise it would remove existing configurations. Make sure you set up the `Acknowledgements.plist` correctly as a Child Pane as shown below:

```xml
<dict>
    <key>Type</key>
    <string>PSChildPaneSpecifier</string>
    <key>Title</key>
    <string>Acknowledgements</string>
    <key>File</key>
    <string>Acknowledgements</string>
</dict>
```

For more information on how to set up and use a Settings Bundle, take a look at Apple's [documentation](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/UserDefaults/Preferences/Preferences.html).

### PDF

On macOS it is more common to show a `Acknowledgments.pdf` file. Therefore you have the option to generate a PDF with all licenses.
Just specify `--output-type pdf` on the command execution.

It uses the project's file name (without extension) as the product name and, if present, the organization-name from the project file.
You can set that in your project's file inspector as shown [here](https://stackoverflow.com/a/38395030/11342085).

Once created and added to the project, it can be easily accessed from the application's bundle like the following:
```swift
import SwiftPackageList

let url = Bundle.main.acknowledgementsURL
```
You can then use [QuickLook](https://developer.apple.com/documentation/quicklook), [NSWorkspace.open(\_:)](https://developer.apple.com/documentation/appkit/nsworkspace/1533463-open) or any other method to display the PDF.

### Custom Packages

To provide custom packages or other items with licenses, you can use the `--custom-packages-file-path` option with a JSON file in the following format:

```json
[
    {
        "branch" : null,
        "identity" : "custom-package-example",
        "kind" : "custom",
        "license" : null,
        "location" : "",
        "name" : "CustomPackageExample",
        "revision" : null,
        "version" : null
    }
]
```

All optional fields have null values in this example and can be left out, the other ones are required.


## Swift Package

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FFelixHerrmann%2Fswift-package-list%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/FelixHerrmann/swift-package-list)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FFelixHerrmann%2Fswift-package-list%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/FelixHerrmann/swift-package-list)

Load the generated package-list file from the bundle or use some pre-build UI components.

### Requirements

- macOS 10.15
- iOS 13.0
- tvOS 13.0
- watchOS 6.0
- visionOS 1.0

### Usage

Add the package to your project as shown [here](https://developer.apple.com/documentation/swift_packages/adding_package_dependencies_to_your_app).

It contains 2 libraries; `SwiftPackageList` for loading the Data and `SwiftPackageListUI` to get an iOS Settings-like user interface.

#### SwiftPackageList

```swift
import SwiftPackageList

let packageProvider = JSONPackageProvider()
do {
    let packages = try packageProvider.packages()
    // use packages
} catch {
    print(error)
}
```

#### SwiftPackageListUI

```swift
import SwiftPackageListUI

let acknowledgmentsViewController = SPLAcknowledgmentsTableViewController()
acknowledgmentsViewController.canOpenRepositoryLink = true
navigationController.pushViewController(acknowledgmentsViewController, animated: true)
```

```swift
import SwiftPackageListUI

var body: some View {
    NavigationStack {
        AcknowledgmentsList()
    }
}
```


## Localization

The Settings Bundle and the UI-components are currently localized in the following languages:

| Name                 | Code    |
| -------------------- | ------- |
| Arabic               | ar      |
| Chinese, Simplified  | zh-Hans |
| Chinese, Traditional | zh-Hant |
| English              | en      |
| French               | fr      |
| German               | de      |
| Hindi                | hi      |
| Italian              | it      |
| Japanese             | ja      |
| Polish               | pl      |
| Portuguese           | pt      |
| Russian              | ru      |
| Spanish              | es      |
| Turkish              | tr      |
| Ukrainian            | uk      |

> If a language has mistakes or is missing, feel free to create an issue or open a pull request.


## Known limitations

- SwiftPackageList won't include license files from packages that are located in a registry like Artifactory.


## License

SwiftPackageList is available under the MIT license. See the [LICENSE](https://github.com/FelixHerrmann/swift-package-list/blob/master/LICENSE) file for more info.
