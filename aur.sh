#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

pushd /tmp
if [[ ! -d yay ]]
then
  git clone --depth 1 https://aur.archlinux.org/yay.git
fi
pushd yay
makepkg --syncdeps --install --noconfirm
