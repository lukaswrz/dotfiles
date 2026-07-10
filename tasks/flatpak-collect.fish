#!/usr/bin/env fish

flatpak list --app --columns=application,origin | awk '$2 == "flathub" { print $1 }' > flatpak.txt
