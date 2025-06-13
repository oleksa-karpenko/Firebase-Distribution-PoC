# Test Routines

TEST_DEVICE="platform=iOS Simulator,name=iPhone 16"
TEST_RESULTS_FILE="./build/TestResults.xcresult"
# Show possible destinations
tdests:
	@echo "🎯 Getting possible test destinations"
	@xcodebuild \
		-project $(XC_PROJ_NAME) \
		-scheme $(XC_PROJ_SCHEMA) \
		-showdestinations 
	@echo "✅ DONE"

# Run All Unit tests, generate CodeCoverage report
tests:
	@echo "🧬 Running all tests..."
	@rm -rf $(TEST_RESULTS_FILE)
	@xcodebuild \
		-project $(XC_PROJ_NAME) \
		-scheme $(XC_PROJ_SCHEMA) \
		-destination $(TEST_DEVICE) \
		-enableCodeCoverage YES \
		-resultBundlePath $(TEST_RESULTS_FILE) \
		test
	@echo "✅ DONE"

# Calculate the Count of Test Functions
tests-count:
	@echo "🧪 Counting Tests via xccov..."
	@COUNT=$$(xcrun xccov view --report $(TEST_RESULTS_FILE) \
		| grep -E '^\s{8}.*\.test[^ ]*\(\)' \
		| wc -l); \
	echo "Tests Count (ps): $$COUNT"

# Calculate the Code Coverage
tcc:
	@echo "📊 Code Coverage Report:"
	@xcrun xccov view --report $(TEST_RESULTS_FILE)
	@echo "✅ DONE"
