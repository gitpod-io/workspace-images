#!/bin/bash
set -euo pipefail

RUBY_VERSION=$1

bash -lc "
rvm requirements \
&& rvm install \"${RUBY_VERSION}\" --default \
&& rvm alias create default \"${RUBY_VERSION}\" \
&& rvm rubygems current \
&& gem install bundler --no-document \
&& gem install solargraph --no-document"
