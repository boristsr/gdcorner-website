#!/bin/bash

# Install some prereqs
sudo apt-get install zlib1g zlib1g-dev

# Install ruby & bundler
sudo apt-get install ruby ruby-dev
sudo gem install bundler

# Install modules for site
bundle install

# Build site
bundle exec jekyll build