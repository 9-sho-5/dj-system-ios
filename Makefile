.DEFAULT_GOAL := setup
PRODUCT_NAME := DJSystemiOS
SCHEME_NAME := DJSystemiOS
PROJECT_NAME := ${PRODUCT_NAME}.xcodeproj
TEST_SDK := iphonesimulator
TEST_CONFIGURATION := Debug
TEST_PLATFORM := iOS Simulator
TEST_DEVICE ?= iPhone 14
TEST_OS ?= 16.2
TEST_DESTINATION := 'platform=${TEST_PLATFORM},name=${TEST_DEVICE},OS=${TEST_OS}'

.PHONY: setup
setup: mint xcodegen open

.PHONY: xcodegen
xcodegen:
	mint run xcodegen

.PHONY: open
open:
	open ${PRODUCT_NAME}.xcodeproj

.PHONY: mint
mint:
	mint bootstrap

.PHONY: test
test:
	xcodebuild \
-sdk ${TEST_SDK} \
-configuration ${TEST_CONFIGURATION} \
-project ${PROJECT_NAME} \
-scheme '${SCHEME_NAME}' \
-destination ${TEST_DESTINATION} \
-parallel-testing-enabled NO \
-enableCodeCoverage YES \
-resultBundlePath TestResults \
test | xcbeautify

.PHONY: build
build:
	xcodebuild \
-configuration ${TEST_CONFIGURATION} \
-project ${PROJECT_NAME} \
-scheme '${SCHEME_NAME}' \
-showBuildTimingSummary \
-destination ${TEST_DESTINATION} \
| xcbeautify

.PHONY: packages
packages:
	xcodebuild -resolvePackageDependencies \
-project ${PROJECT_NAME} \
-destination ${TEST_DESTINATION} \
-scheme ${SCHEME_NAME} \
| xcbeautify

.PHONY: clean
clean:
	xcodebuild clean -project ${PROJECT_NAME}

