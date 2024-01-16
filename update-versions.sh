#!/bin/bash

version=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/sabnzbd/sabnzbd/releases/latest" | jq -r .tag_name | sed s/v//g)
[[ -z ${version} ]] && exit 0
par2turbo_version=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/animetosho/par2cmdline-turbo/releases/latest" | jq -r .tag_name | sed s/v//g)
[[ -z ${par2turbo_version} ]] && exit 0
nzbnotify_version=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/caronc/nzb-notify/releases/latest" | jq -r .tag_name | sed s/v//g)
[[ -z ${nzbnotify_version} ]] && exit 0
old_version=$(jq -r '.version' < VERSION.json)
changelog=$(jq -r '.changelog' < VERSION.json)
[[ "${old_version}" != "${version}" ]] && changelog="https://github.com/sabnzbd/sabnzbd/compare/${old_version}...${version}"
version_json=$(cat ./VERSION.json)
jq '.version = "'"${version}"'" | .par2turbo_version = "'"${par2turbo_version}"'" | .nzbnotify_version = "'"${nzbnotify_version}"'" | .changelog = "'"${changelog}"'"' <<< "${version_json}" > VERSION.json
