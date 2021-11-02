#!/bin/sh
swift build --configuration release
cp -f .build/release/SwiftPackageListCommand /usr/local/bin/swift-package-list
