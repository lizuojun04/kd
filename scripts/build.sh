#!/usr/bin/env bash
set -eu

cd "$(dirname "$0")/.."
output=${1:-build/kd_linux_amd64}
mkdir -p "$(dirname "$output")"
ldflags="-s -w"
if [[ -n ${KD_VERSION:-} ]]; then
    ldflags+=" -X main.VERSION=$KD_VERSION"
fi

GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -mod=readonly \
    -ldflags="$ldflags" -tags urfave_cli_no_docs -o "$output" ./cmd/kd
