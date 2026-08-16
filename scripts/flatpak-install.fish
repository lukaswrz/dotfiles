#!/usr/bin/env fish

for app in (cat flatpak.txt)
    if test -z "$app"
        continue
    end

    if string match -qr '^\s*#' "$app"
        continue
    end

    flatpak install --assumeyes flathub "$app"
end
