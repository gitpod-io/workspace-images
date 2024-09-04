#!/bin/bash
set -euo pipefail

RUBY_VERSION=$1

bash -lc "
rvm requirements \
&& rvm install \"${RUBY_VERSION}\" --default \
&& rvm alias create default \"${RUBY_VERSION}\" \
&& rvm rubygems current \
&& gem install bundler --no-document"

# Ruby 3.3 is not yet supported by solargraph https://github.com/castwide/solargraph/issues/706
if ! grep -q "3.3." <<<"${RUBY_VERSION}"; then
	bash -lc "gem install solargraph --no-document"
fi
