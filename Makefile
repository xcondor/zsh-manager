.PHONY: all run build test package dmg clean debug-dmg

APP_NAME = ZshrcManager
BINARY = .build/debug/$(APP_NAME)
RELEASE_BINARY = .build/release/$(APP_NAME)

all: run

# Run tests and verify core functions
test:
	@echo "🧪 Running unit tests..."
	@swift test

# Fast iteration: Run tests, build, and run
run: test
	@echo "🔄 Build & Run $(APP_NAME)..."
	@pkill $(APP_NAME) || true
	@swift build
	@codesign -s - $(BINARY) || true
	@echo "🚀 Launching $(APP_NAME)..."
	@./$(BINARY) &

# Standard build with test validation
build: test
	@swift build
	@codesign -s - $(BINARY) || true

# Release build
release: test
	@swift build -c release

# Package as .app bundle
package: test
	@chmod +x scripts/package.sh
	@./scripts/package.sh

# Generate DMG installer
dmg: package
	@echo "📦 DMG generated at dist/$(APP_NAME).dmg"

# Generate Debug DMG installer
debug-dmg:
	@chmod +x scripts/package.sh
	@DEBUG=1 ./scripts/package.sh
	@echo "📦 Debug DMG generated at dist/$(APP_NAME)-Debug.dmg"

# Clean build artifacts
clean:
	@rm -rf .build
	@rm -rf dist
	@echo "🧹 Cleaned build and dist folders."
