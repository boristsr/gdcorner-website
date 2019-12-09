#!/bin/bash

# Install some prereqs
apt-get install -y zlib1g zlib1g-dev

# Install ruby & bundler
apt-get install -y ruby ruby-dev
gem install bundler

# Install modules for site
bundle install

# Build site
bundle exec jekyll build