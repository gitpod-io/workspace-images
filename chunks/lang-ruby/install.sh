#!/bin/bash
set -euo pipefail

RUBY_VERSION=$1

# the version of openssl changed in Jammy, Ruby 3.0 needs an older version
# https://github.com/rvm/rvm/issues/5209#issuecomment-1114159447
# another option: https://github.com/rvm/rvm/issues/5209#issuecomment-1134927685 or sudo apt install libssl-dev=1.1.1l-1ubuntu1.4
if grep -q "3.0." <<<"${RUBY_VERSION}"; then
	bash -lc "
        rvm requirements \
        && rvm pkg install openssl \
        && rvm install \"${RUBY_VERSION}\" --with-openssl-dir=\"${HOME}\"/.rvm/usr --default \
        && rvm alias create default \"${RUBY_VERSION}\" \
        && rvm rubygems current \
        && gem install bundler --no-document \
        && gem install solargraph --no-document"
else
	# Ruby 3.1 and higher do not
	bash -lc "
        rvm requirements \
        && rvm install \"${RUBY_VERSION}\" --default \
        && rvm alias create default \"${RUBY_VERSION}\" \
        && rvm rubygems current \
        && gem install bundler --no-document \
        && gem install solargraph --no-document"
fi
