# Copyright 2023-2024 Bitwise IO, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

build: build-jekyll

build-api:
    #!/usr/bin/env sh
    set -e
    for version in 0.1 0.2 0.3 0.4
    do
        cmd="redoc-cli build docs/$version/references/api/openapi.yaml -o docs/$version/api/index.html"
        echo "\033[1m$cmd\033[0m"
        $cmd

        echo
        echo "** In MacOS: open docs/$version/api/index.html"
    done

    cmd="redoc-cli build community/planning/rest_api/openapi.yaml -o community/planning/rest_api/api/index.html"
    echo "\033[1m$cmd\033[0m"
    $cmd

    echo
    echo "** In MacOS: open community/planning/rest_api/api/index.html"

    echo "\n\033[92mBuild API Success\033[0m\n"

build-jekyll: build-api
    #!/usr/bin/env sh
    set -e

    if [ $(uname -s) = "Darwin" ]; then
        export RUBY_VERSION=3.1.3
        source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh
        chruby ruby-$RUBY_VERSION
    fi

    bundle install
    bundle exec jekyll build

clean:
    rm -rf \
        .jekyll-metadata/ \
        _site/ \
        docs/0.1/api/ \
        docs/0.2/api/ \
        docs/0.3/api/ \
        docs/0.4/api/ \
        community/planning/rest_api/api/ \
        Gemfile.lock

install-jekyll-via-brew:
    #!/usr/bin/env sh
    set -e

    brew install chruby ruby-install xz

    export RUBY_VERSION=3.1.3
    ruby-install ruby $RUBY_VERSION --no-reinstall --cleanup
    source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh
    chruby ruby-$RUBY_VERSION

    gem install jekyll bundler mdl

install-mdl:
    #!/usr/bin/env sh
    set -e

    if [ $(uname -s) = "Darwin" ]; then
        export RUBY_VERSION=3.1.3
        source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh
        chruby ruby-$RUBY_VERSION
    fi

    gem install mdl

run: build-api
    #!/usr/bin/env sh
    set -e

    if [ $(uname -s) = "Darwin" ]; then
        export RUBY_VERSION=3.1.3
        source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh
        chruby ruby-$RUBY_VERSION
    fi

    bundle install
    bundle exec jekyll serve --incremental

lint:
    #!/usr/bin/env sh
    set -e

    if [ $(uname -s) = "Darwin" ]; then
        export RUBY_VERSION=3.1.3
        source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh
        chruby ruby-$RUBY_VERSION
    fi

    mdl -g -i -r ~MD001,~MD002,~MD004,~MD005,~MD006,~MD007,~MD009,~MD010,~MD012,~MD013,~MD014,~MD022,~MD024,~MD026,~MD029,~MD030,~MD031,~MD032,~MD033,~MD034,~MD036,~MD046,~MD047,~MD055,~MD056,~MD057 .
