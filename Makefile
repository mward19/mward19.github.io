# Extract version from typst.toml
VERSION := $(shell grep '^version = ' typst.toml | sed 's/version = "\(.*\)"/\1/')

# Get the root directory of the project
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

# Define phony (non-file) targets
.PHONY: link link-macos link-linux link-windows sync-assets check build

# Create symlink to local package cache
link:
ifeq ($(OS),Windows_NT)
	$(MAKE) link-windows
else
ifeq ($(shell uname), Darwin)
	$(MAKE) link-macos
else ifeq ($(shell uname), Linux)
	$(MAKE) link-linux
else
	@echo "Unsupported OS"
	@exit 1
endif
endif

link-macos:
	mkdir -p ~/Library/Caches/typst/packages/preview/tufted
	ln -sf $(ROOT_DIR) ~/Library/Caches/typst/packages/preview/tufted/$(VERSION)

link-linux:
	mkdir -p ~/.cache/typst/packages/preview/tufted
	ln -sf $(ROOT_DIR) ~/.cache/typst/packages/preview/tufted/$(VERSION)
# TODO: Test on Windows
link-windows:
	if not exist "%LOCALAPPDATA%\typst\packages\preview\tufted" mkdir "%LOCALAPPDATA%\typst\packages\preview\tufted"
	mklink /D "%LOCALAPPDATA%\typst\packages\preview\tufted\$(VERSION)" .


ASSETS := devices.webp
sync-assets:
	@mkdir -p assets
	@for asset in $(ASSETS); do \
		rm -f "assets/$$asset"; \
		cp "template/assets/$$asset" "assets/$$asset"; \
	done

clean:
	rm -rf template/_site
	find . -name ".DS_Store" -delete

# Check package for common issues
check:
	typst-package-check check

# Build a zip archive for submission
build: sync-assets clean
	zip -r tufted-${VERSION}.zip src/ template/ assets/ LICENSE README.md typst.toml
