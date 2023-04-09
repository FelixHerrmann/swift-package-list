BUILD_PATH=.build/release/swift-package-list
BIN_PATH=/usr/local/bin
INSTALL_PATH=$(BIN_PATH)/swift-package-list

all: install

build:
	swift build --configuration release --product swift-package-list

install: build
	sudo mkdir -p $(BIN_PATH)
	sudo cp -f $(BUILD_PATH) $(INSTALL_PATH)

uninstall:
	sudo rm -f $(INSTALL_PATH)

update: uninstall install
