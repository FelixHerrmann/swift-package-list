#!/bin/sh
swift build --configuration release
cp -f .build/release/SwiftPackageList /usr/local/bin/swift-package-list
