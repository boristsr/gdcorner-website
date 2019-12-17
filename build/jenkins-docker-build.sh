#!/bin/bash

# Install modules for site
bundle install

BUILD_ENVIRONMENT="${BUILD_ENVIRONMENT:-development}"

if [[ -n "${OVERRIDE_URL}" ]]; then
  echo "Ovverride url provided, modifying _config.yml"
  sed -i \
        -e 's!^url:.*!url: \"'"${OVERRIDE_URL}"'\"!' \
        _config.yml

  rm _config.yml-e
fi

echo Building in mode: $BUILD_ENVIRONMENT

# Build site
JEKYLL_ENV=$BUILD_ENVIRONMENT bundle exec jekyll build
