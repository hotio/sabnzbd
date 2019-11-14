#!/bin/bash

version=$(curl -fsSL "https://api.github.com/repos/sabnzbd/sabnzbd/releases/latest" | jq -r .tag_name | sed s/v//g)
find . -type f -name '*.Dockerfile' -exec sed -i "s/ARG SABNZBD_VERSION=.*$/ARG SABNZBD_VERSION=${version}/g" {} \;
sed -i "s/{TAG_VERSION=.*}$/{TAG_VERSION=${version}}/g" .drone.yml
echo "##[set-output name=version;]${version}"
