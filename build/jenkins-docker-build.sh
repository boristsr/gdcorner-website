#!/bin/bash

# Install modules for site
bundle install

BUILD_ENVIRONMENT="${BUILD_ENVIRONMENT:-development}"

echo Building in mode: $BUILD_ENVIRONMENT

# Build site
JEKYLL_ENV=$BUILD_ENVIRONMENT bundle exec jekyll build
