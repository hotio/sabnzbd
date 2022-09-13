#!/bin/bash

version=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/sabnzbd/sabnzbd/commits/develop" | jq -r .sha)
[[ -z ${version} ]] && exit 0
old_version=$(jq -r '.version' < VERSION.json)
changelog=$(jq -r '.changelog' < VERSION.json)
[[ "${old_version}" != "${version}" ]] && changelog="https://github.com/sabnzbd/sabnzbd/compare/${old_version}...${version}"
version_json=$(cat ./VERSION.json)
jq '.version = "'"${version}"'" | .changelog = "'"${changelog}"'"' <<< "${version_json}" > VERSION.json
