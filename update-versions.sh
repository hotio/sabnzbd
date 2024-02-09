#!/bin/bash
version=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/sabnzbd/sabnzbd/releases" | jq -re .[0].tag_name) || exit 1
par2turbo_version=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/animetosho/par2cmdline-turbo/releases/latest" | jq -re .tag_name) || exit 1
nzbnotify_version=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/caronc/nzb-notify/releases/latest" | jq -re .tag_name) || exit 1
json=$(cat VERSION.json)
jq --sort-keys \
    --arg version "${version//v/}" \
    --arg par2turbo_version "${par2turbo_version//v/}" \
    --arg nzbnotify_version "${nzbnotify_version//v/}" \
    '.version = $version | .par2turbo_version = $par2turbo_version | .nzbnotify_version = $nzbnotify_version' <<< "${json}" | tee VERSION.json
