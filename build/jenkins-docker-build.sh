#!/bin/bash

# Install some prereqs
sudo apt-get install -y zlib1g zlib1g-dev

# Install ruby & bundler
sudo apt-get install -y ruby ruby-dev
sudo gem install bundler

# Install modules for site
bundle install

# Build site
bundle exec jekyll build