#!/bin/bash
set -exuo pipefail

version=$(curl -fsSL "https://api.github.com/repos/sabnzbd/sabnzbd/releases" | jq -re .[0].tag_name)
version_par2turbo=$(curl -fsSL "https://api.github.com/repos/animetosho/par2cmdline-turbo/releases/latest" | jq -re .tag_name)
json=$(cat meta.json)
jq --sort-keys \
    --arg version "${version//v/}" \
    --arg version_par2turbo "${version_par2turbo//v/}" \
    '.version = $version | .version_par2turbo = $version_par2turbo' <<< "${json}" | tee meta.json
