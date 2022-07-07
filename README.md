# SwiftPackageList

[![Version](https://img.shields.io/github/v/release/FelixHerrmann/swift-package-list)](https://github.com/FelixHerrmann/swift-package-list/releases)
[![License](https://img.shields.io/github/license/FelixHerrmann/swift-package-list)](https://github.com/FelixHerrmann/swift-package-list/blob/master/LICENSE)
[![Tweet](https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Fgithub.com%2FFelixHerrmann%2Fswift-package-list)](https://twitter.com/intent/tweet?text=Wow:&url=https%3A%2F%2Fgithub.com%2FFelixHerrmann%2Fswift-package-list)

[![Xcode Build](https://github.com/FelixHerrmann/swift-package-list/actions/workflows/xcodebuild.yml/badge.svg)](https://github.com/FelixHerrmann/swift-package-list/actions/workflows/xcodebuild.yml)

A command-line tool to generate a JSON, PLIST, Settings.bundle or PDF file with all used SPM-dependencies of an Xcode project or workspace.

This includes all the `Package.resolved` informations and the license from the checkouts.
Additionally there is a Swift Package to read the generated package-list file from the application's bundle with a top-level function or pre-build UI.


## Command-Line Tool

### Installation

#### Using [Mint](https://github.com/yonaskolb/mint):

```shell
mint install FelixHerrmann/swift-package-list
```

#### Installing from source:

Clone or download this repository and run `make install`, `make update` or `make uninstall` (with sudo if required).

### Usage

Open the terminal and run `swift-package-list <project-path>` with the path to the `.xcodeproj` or `.xcworkspace` file you want to generate the list from.

In addition to that you can specify the following options:

| Option                                            | Description                                                                                                                   |
| ------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| -d, --derived-data-path \<derived-data-path\>     | The path to your DerivedData-folder. (default: ~/Library/Developer/Xcode/DerivedData)                                         |
| -s, --source-packages-path <source-packages-path> | The path to a custom SourcePackages-folder.                                                                                   |
| -o, --output-path \<output-path\>                 | The path where the package-list file will be stored. (default: ~/Desktop)                                                     |
| -f, --file-type \<file-type\>                     | The file type of the generated package-list file. Available options are json, plist, settings-bundle and pdf. (default: json) |
| -c, --custom-file-name <custom-file-name>         | A custom filename to be used instead of the default ones.                                                                     |
| --requires-license                                | Will skip the packages without a license-file.                                                                                |
| --version                                         | Show the version.                                                                                                             |
| -h, --help                                        | Show help information.                                                                                                        |

### Run Script Phase

You can easily set up a Run Script Phase in your target of your Xcode project to keep the package-list file up to date automatically:

1. open the corresponding target and click on the plus under the *Build Phases* section
2. select *New Run Script Phase* and add the following script into the code box:
```shell
if command -v swift-package-list &> /dev/null; then
    OUTPUT_PATH=$SOURCE_ROOT/$TARGETNAME
    swift-package-list "$PROJECT_FILE_PATH" --output-path "$OUTPUT_PATH" --requires-license
else
    echo "warning: swift-package-list not installed"
fi
```
3. move the Phase above the `Copy Bundle Resources`-phase
4. optionally you can rename the Phase by double-clicking on the title
5. build your project (cmd + b)
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
    swift-package-list "$WORKSPACE_FILE_PATH" --output-path "$OUTPUT_PATH" --requires-license
else
    echo "warning: swift-package-list not installed"
fi
```

#### Mint Troubleshooting

If you used Mint to install the Command-Line Tool, Xcode will not recognize the swift-package-list command.
This is because Mint uses it's own /bin directory and Xcode's PATH environment variable is not aware of that.
There are 2 easy ways to fix this issue:

- add `export PATH="$PATH:$HOME/.mint/bin/"` as the first line to your build script
- execute `ln -s $HOME/.mint/bin/swift-package-list /usr/local/bin/swift-package-list` in your Terminal

### Settings Bundle

You can also generate a `Settings.bundle` file to show the acknowledgements in the Settings app. This works slightly different
than the other file types, because a Settings Bundle is a collection of several files and might already exist in your app. 
Just specify `--file-type settings-bundle` on the command execution.

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
Just specify `--file-type pdf` on the command execution.

It uses the project's file name (without extension) as the product name and, if present, the organization-name from the project file.
You can set that in your project's file inspector as shown [here](https://stackoverflow.com/a/38395030/11342085).

Once created and added to the project, it can be easily accessed from the application's bundle like the following:
```swift
let url = Bundle.main.url(forResource: "Acknowledgements", withExtension: "pdf")
```
You can then use [QuickLook](https://developer.apple.com/documentation/quicklook), [NSWorkspace.open(\_:)](https://developer.apple.com/documentation/appkit/nsworkspace/1533463-open) or any other method to display the PDF.


## Swift Package

Load `package-list.json` or `package-list.plist` from the bundle with a single function call or use the pre-build UI components.

### Requirements

- macOS 10.10+
- iOS 9.0+
- tvOS 9.0+
- watchOS 2.0+

### Usage

Add the package to your project as shown [here](https://developer.apple.com/documentation/swift_packages/adding_package_dependencies_to_your_app).

It contains 3 libraries; `SwiftPackageList`/`SwiftPackageListObjc` for loading the Data in Swift and Objective-C 
and `SwiftPackageListUI` to get an iOS Settings-like user interface.

#### SwiftPackageList

```swift
import SwiftPackageList

do {
    let packages = try packageList()
    // use packages
} catch PackageListError.noPackageList {
    print("There is no package-list file")
} catch {
    print(error)
}
```

#### SwiftPackageListObjc

```objc
@import SwiftPackageListObjc;

NSError *error;
NSArray<SPLPackage *> *packages = SPLPackageList(&error);
if (packages) {
    // use packages
} else {
    if (error.code == SPLErrorNoPackageList) {
        NSLog(@"There is no package-list file");
    } else {
        NSLog(@"%@", error);
    }
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
    NavigationView {
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
| Portuguese           | pt      |
| Russian              | ru      |
| Spanish              | es      |

> If a language has mistakes or is missing, feel free to create an issue or open a pull request.


## License

SwiftPackageList is available under the MIT license. See the [LICENSE](https://github.com/FelixHerrmann/swift-package-list/blob/master/LICENSE) file for more info.
