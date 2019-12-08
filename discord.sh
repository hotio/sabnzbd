#!/bin/bash

if [[ "${DRONE_BUILD_STATUS}" == "success" ]]; then
    message="succeeded"
    color="65280"
else
    message="failed"
    color="16711680"
fi

[[ -f "/drone/src/screenshot.log" ]] && screenshot_url=$(cat "/drone/src/screenshot.log")
[[ -n "${screenshot_url}" ]] && thumbnail=',"thumbnail": {"url": "'${screenshot_url}'"}'
[[ -n "${VERSION}" ]] && version_field=',"fields":[{"name":"Version","value":"'${VERSION}'"}]'

curl -fsSL -H "Content-Type: application/json" \
-X POST -d '{"embeds":[{"description":"Build **[#'"${DRONE_BUILD_NUMBER}"'](https://cloud.drone.io/'"${DRONE_REPO}"'/'"${DRONE_BUILD_NUMBER}"')** of `'"${DRONE_REPO//docker-/}"':'"${DRONE_COMMIT_BRANCH}"'` '"${message}"'.\n\nCommit **['"${DRONE_COMMIT_SHA:0:7}"']('"${DRONE_COMMIT_LINK}"')** by **'"${DRONE_COMMIT_AUTHOR}"'**:\n```'"${DRONE_COMMIT_MESSAGE//\"/}"'```","color":'"${color}${version_field}${thumbnail}"',"timestamp": "'"$(date -u --iso-8601=seconds)"'"}]}' "https://discordapp.com/api/webhooks/${DISCORD_ID}/${DISCORD_TOKEN}"
