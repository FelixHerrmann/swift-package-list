BUILD_PATH=.build/release/SwiftPackageListCommand
INSTALL_PATH=/usr/local/bin/swift-package-list

all:
	install

install:
	swift build --configuration release
	cp -f "$(BUILD_PATH)" "$(INSTALL_PATH)"

uninstall:
	rm -f "$(INSTALL_PATH)"

update:
	sh uninstall.sh
	sh install.sh
