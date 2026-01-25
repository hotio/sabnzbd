#!/bin/bash
set -exuo pipefail

version=$(curl -fsSL --header "Authorization: Bearer ${GITHUB_TOKEN}" "https://api.github.com/repos/sabnzbd/sabnzbd/commits/develop" | jq -re .sha)
version_par2turbo=$(curl -fsSL --header "Authorization: Bearer ${GITHUB_TOKEN}" "https://api.github.com/repos/animetosho/par2cmdline-turbo/releases/latest" | jq -re .tag_name)
json=$(cat meta.json)
jq --sort-keys \
    --arg version "${version//v/}" \
    --arg version_par2turbo "${version_par2turbo//v/}" \
    '.version = $version | .version_par2turbo = $version_par2turbo' <<< "${json}" | tee meta.json
