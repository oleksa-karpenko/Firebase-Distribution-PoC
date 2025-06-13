# Shared variables
APP_NAME="FBDistributionPoC"

# Xcode project options
XC_PROJ_NAME="${APP_NAME}.xcodeproj"
XC_PROJ_SCHEMA="${APP_NAME}"
XC_PROJ_CONFIG="Release"

#include ./make/setup.mk
include ./make/develop.mk
#include ./make/dependencies.mk
#include ./make/run.mk
include ./make/test.mk
include ./make/version.mk
include ./make/release.mk

include ./.env
export
