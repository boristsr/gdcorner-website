#!/bin/bash

BUILD_ENVIRONMENT="${BUILD_ENVIRONMENT:-development}"

CONFIG_FILES="_config.yml"

if [[ "${BRANCH_NAME}" == "uattest" ]]; then
  echo "Building with UAT Configuration"
  CONFIG_FILES="_config.yml,_config_uattest.yml"
  BUILD_ENVIRONMENT='staging'
elif [[ "${BRANCH_NAME}" == "staging" ]]; then
  echo "Building with STAGING Configuration"
  echo "Development build, building with extra config data"
  CONFIG_FILES="_config.yml,_config_staging.yml"
  BUILD_ENVIRONMENT='staging'
elif [[ "${BRANCH_NAME}" == "master" ]]; then
  echo "Building with PRODUCTION Configuration"
  CONFIG_FILES="_config.yml,_config_production.yml"
  BUILD_ENVIRONMENT='production'
fi

echo Building in mode: $BUILD_ENVIRONMENT

# Build site
JEKYLL_ENV=$BUILD_ENVIRONMENT bundle exec jekyll build --config ${CONFIG_FILES}
