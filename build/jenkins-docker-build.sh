#!/bin/bash

# Install modules for site
bundle install

BUILD_ENVIRONMENT="${BUILD_ENVIRONMENT:-development}"

if [[ -z "${OVERRIDE_URL}" ]]; then
  sed -i _config.yml \
        -e 's/url:.*/url: $OVERRIDE_URL/'

  cat _config.yml
fi

echo Building in mode: $BUILD_ENVIRONMENT

# Build site
JEKYLL_ENV=$BUILD_ENVIRONMENT bundle exec jekyll build
