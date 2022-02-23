#!/bin/bash

set -euxo pipefail

# Per https://stackoverflow.com/a/16349776; go to repo root
cd "${0%/*}/../../.."

# Build test_suite.wasm
cargo run -p cargo-zaplib -- build -p test_suite

# Build
pushd zaplib/web
    # Publish early, in case you want to use this even when there
    # are still some failing tests
    yarn install
    yarn run build
    yarn run build-dev
    npm version 0.0.0-$(git rev-parse --short HEAD)
    npm publish --tag canary

    # JS Tests
    yarn lint

    # Run jest (uses test suite)
    yarn run jest --forceExit
popd
