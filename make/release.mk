# Make Releases

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
	@echo "STAT:"
	@make v-get
	@echo "--------------------------------------------------"
	@echo "LOC (excluding *.g.dart and *.mocks.dart files)"
	@echo "Lib:   $$(find lib  -name '*.dart' ! -name '*.g.dart' ! -name '*.mocks.dart' | xargs wc -l | tail -n 1 | awk '{print $$1}')"
	@echo "Tests: $$(find test -name '*.dart' ! -name '*.g.dart' ! -name '*.mocks.dart' | xargs wc -l | tail -n 1 | awk '{print $$1}')"
	@echo "--------------------------------------------------"
	@echo "5 biggest files in the repository"
	@find lib  -name '*.swift' ! -name '*.g.dart' ! -name '*.mocks.dart' -exec wc -l '{}' \+ 2>/dev/null | sort -r --human-numeric-sort | head -n 6
	@echo "--------------------------------------------------"
	@echo "DONE"


# ----------------------------------------------------------------------------
# IOS BUILD AND DISTRIBUTION

# Clean the project. Do this before making the Archive
r-clean:
	xcodebuild clean -project "$(XC_PROJ_NAME)" -scheme "$(XC_PROJ_SCHEMA)" -configuration "$(XC_PROJ_CONFIG)"

# Make an iOS Archive, when done you can find it in the ./build folder
r-arch:
	xcodebuild archive \
		-project "$(XC_PROJ_NAME)" \
		-scheme "$(XC_PROJ_SCHEMA)" \
		-archivePath "$(ARCHIVE)" \
		-configuration "$(XC_PROJ_CONFIG)" \
		-destination 'generic/platform=iOS'

# Export ipa from the archive. IPA file will be in the same folder as archive (./build)
r-ipa:
	xcodebuild -exportArchive \
	-archivePath $(ARCHIVE) \
	-exportOptionsPlist ./ExportOptions.plist \
	-exportPath $(BUILD_OUTPUT) \
	-allowProvisioningUpdates


# Distribute to the Firebase. Do not forget to have updated Release-Notes.txt
r-distr:
	firebase appdistribution:distribute $(IPA_FILE) \
		--app $(FB_APP_ID) \
		--release-notes-file $(RELEASE_NOTES_FILE) \
		--groups $(FB_TESTER_GROUP) \
		--token "$(FB_TOKEN)"

