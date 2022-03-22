#!/bin/bash

# Install modules for site
bundle install

BUILD_ENVIRONMENT="${BUILD_ENVIRONMENT:-development}"

CONFIG_FILES="_config.yml"

if [[ "${BUILD_ENVIRONMENT}" ]]; then
  echo "Development build, building with extra config data"
  CONFIG_FILES="_config.yml,_config_development.yml"
fi

echo Building in mode: $BUILD_ENVIRONMENT

# Build site
JEKYLL_ENV=$BUILD_ENVIRONMENT bundle exec jekyll build --config ${CONFIG_FILES}
