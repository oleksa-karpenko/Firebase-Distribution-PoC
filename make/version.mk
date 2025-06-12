# MARKETING_VERSION = CFBundleShortVersionString (e.g., 1.2.3)
# CURRENT_PROJECT_VERSION = CFBundleVersion (e.g., 42)
CONFIG_FILE := ./FBDistributionPoC/Config.xcconfig

.PHONY: v-get v-inc-build v-inc-patch v-inc-minor

# Get the current version of the application (stored in the $PROJECT/Confog.xcconfig
v-get:
	@VERSION=$$(grep '^VERSION' $(CONFIG_FILE) | cut -d= -f2 | tr -d ' '); \
	BUILD=$$(grep '^BUILD_NUMBER' $(CONFIG_FILE) | cut -d= -f2 | tr -d ' '); \
	echo "Current version: $$VERSION ($$BUILD)"

# Increase the BUILD number, no push to repository
v-inc-build:
	@BUILD=$$(grep '^BUILD_NUMBER' $(CONFIG_FILE) | cut -d= -f2 | tr -d ' '); \
	NEW_BUILD=$$((BUILD + 1)); \
	sed -i '' "s/^BUILD_NUMBER = .*/BUILD_NUMBER = $$NEW_BUILD/" $(CONFIG_FILE); \
	echo "Incremented build number to $$NEW_BUILD"; \
	# git add $(CONFIG_FILE); \
	# git commit -m "?? Increment build number to $$NEW_BUILD"; \
	# git push


# Increase the PATCH version, no push to repository
v-inc-patch:
	@VERSION=$$(grep '^VERSION' $(CONFIG_FILE) | cut -d= -f2 | tr -d ' '); \
	MAJOR=$$(echo $$VERSION | cut -d. -f1); \
	MINOR=$$(echo $$VERSION | cut -d. -f2); \
	PATCH=$$(echo $$VERSION | cut -d. -f3); \
	NEW_PATCH=$$((PATCH + 1)); \
	NEW_VERSION=$$MAJOR.$$MINOR.$$NEW_PATCH; \
	sed -i '' "s/^VERSION = .*/VERSION = $$NEW_VERSION/" $(CONFIG_FILE); \
	echo "Incremented patch version to $$NEW_VERSION"


# Increase the MINOR version, no push to repository
v-inc-minor:
	@VERSION=$$(grep '^VERSION' $(CONFIG_FILE) | cut -d= -f2 | tr -d ' '); \
	MAJOR=$$(echo $$VERSION | cut -d. -f1); \
	MINOR=$$(echo $$VERSION | cut -d. -f2); \
	NEW_MINOR=$$((MINOR + 1)); \
	NEW_VERSION=$$MAJOR.$$NEW_MINOR.0; \
	sed -i '' "s/^VERSION = .*/VERSION = $$NEW_VERSION/" $(CONFIG_FILE); \
	echo "Incremented minor version to $$NEW_VERSION"
