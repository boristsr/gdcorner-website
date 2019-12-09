#!/bin/bash

# Install modules for site
bundle install

BUILD_ENVIRONMENT="${BUILD_ENVIRONMENT:development}"

# Build site
JEKYLL_ENV=$BUILD_ENVIRONMENT bundle exec jekyll build