#!/bin/bash
set -exuo pipefail

version=$(curl -fsSL "https://api.github.com/repos/sabnzbd/sabnzbd/commits/develop" | jq -re .sha)
par2turbo_version=$(curl -fsSL "https://api.github.com/repos/animetosho/par2cmdline-turbo/releases/latest" | jq -re .tag_name)
json=$(cat VERSION.json)
jq --sort-keys \
    --arg version "${version//v/}" \
    --arg par2turbo_version "${par2turbo_version//v/}" \
    '.version = $version | .par2turbo_version = $par2turbo_version' <<< "${json}" | tee VERSION.json
