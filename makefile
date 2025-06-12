#include ./make/setup.mk
include ./make/develop.mk
#include ./make/dependencies.mk
#include ./make/run.mk
#include ./make/test.mk
include ./make/version.mk
include ./make/release.mk

include ./.env
export
