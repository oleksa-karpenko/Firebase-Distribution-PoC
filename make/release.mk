# Release Routines

# Files
APP_NAME="FBDistributionPoC"
RELEASE_NOTES_FILE="./release-notes.txt"

# FIREBASE OPTIONS
#FB_TOKEN="Value will be read from the .env file"
#FB_APP_ID="Value will be read from the .env file"
FB_TESTER_GROUP="dev_testers"

# Xcode project options
XC_PROJ_NAME="${APP_NAME}.xcodeproj"
XC_PROJ_SCHEMA="${APP_NAME}"
XC_PROJ_CONFIG="Release"

# Output options
BUILD_OUTPUT="./build"
ARCHIVE="$(BUILD_OUTPUT)/$(APP_NAME).xcarchive"
IPA_FILE="./build/$(APP_NAME).ipa"

# Show generic statistics on the codebase
stat:
	@echo "📊 PROJECT STATISTICS"
	@echo "────────────────────────────────────────────────────────"

	@echo "📦 Swift Files (excluding generated and tests)"
	@find . -name '*.swift' ! -name '*Generated*' ! -path '*Tests*' -exec wc -l {} \+ | awk '{s+=$$1} END {print "LOC: ", s}'

	@echo "🧪 Test Files"
	@find . -name '*Tests.swift' -exec wc -l {} \+ | awk '{s+=$$1} END {print "Test LOC: ", s}'

	@echo "📦 Total Swift Files"
	@find . -name '*.swift' | wc -l | xargs -I{} echo "Swift files:	{}"

	@echo "────────────────────────────────────────────────────────"
	@echo "🧱 Top 5 Largest Swift Files (by LOC)"
	@find . -name '*.swift' -exec wc -l {} \+ 2>/dev/null | sort -rn | head -n 5

	@echo "────────────────────────────────────────────────────────"
	@echo "✅ DONE"


# ----------------------------------------------------------------------------
# IOS BUILD AND DISTRIBUTION

# Clean the project. Do this before making the Archive
release-clean:
	@echo "🧹 Cleaning the project..."
	@xcodebuild clean -project "$(XC_PROJ_NAME)" -scheme "$(XC_PROJ_SCHEMA)" -configuration "$(XC_PROJ_CONFIG)"
	@echo "🧹 Cleaning the build output..."
	@rm -rf "$(BUILD_OUTPUT)"
	@echo "✅ DONE"

# Make an iOS Archive, when done you can find it in the ./build folder
release-arch:
	@echo "📦 Archiving app to $(ARCHIVE)..."
	@xcodebuild archive \
		-project "$(XC_PROJ_NAME)" \
		-scheme "$(XC_PROJ_SCHEMA)" \
		-archivePath "$(ARCHIVE)" \
		-configuration "$(XC_PROJ_CONFIG)" \
		-destination 'generic/platform=iOS'
	@echo "📦 DONE"

# Export ipa from the archive. IPA file will be in the same folder as archive (./build)
release-ipa:
	@echo "📱 Exporting IPA to $(BUILD_OUTPUT)..."
	@if [ ! -d "$(ARCHIVE)" ]; then \
		echo "❌ Archive not found: $(ARCHIVE)"; exit 1; \
	fi
	@xcodebuild -exportArchive \
		-archivePath $(ARCHIVE) \
		-exportOptionsPlist ./ExportOptions.plist \
		-exportPath $(BUILD_OUTPUT) \
		-allowProvisioningUpdates
	@echo "✅ DONE"


# Distribute to the Firebase. Do not forget to have updated Release-Notes.txt
release-distr:
	@echo "🚀 Distributing IPA via Firebase App Distribution..."
	@if [ ! -f "$(IPA_FILE)" ]; then \
		echo "❌ IPA file not found: $(IPA_FILE)"; exit 1; \
	fi
	@if [ ! -f "$(RELEASE_NOTES_FILE)" ]; then \
		echo "❌ Release notes not found: $(RELEASE_NOTES_FILE)"; exit 1; \
	fi
	# @firebase appdistribution:distribute $(IPA_FILE) \
	# 	--app $(FB_APP_ID) \
	# 	--release-notes-file $(RELEASE_NOTES_FILE) \
	# 	--groups $(FB_TESTER_GROUP) \
	# 	--token "$(FB_TOKEN)"
	@echo "✅ DONE"

# Run the full release pipeline
release-full: release-clean release-arch release-ipa release-distr
	@echo "🎉 Release process completed successfully!"