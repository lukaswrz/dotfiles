#!/usr/bin/env fish

set -l wanted

for app in (cat flatpak.txt)
    set app (string trim "$app")

    if test -z "$app"
        continue
    end

    if string match -qr '^#' "$app"
        continue
    end

    set wanted $wanted "$app"
end

flatpak list --app --columns=application,origin | while read -l app origin
    if test "$origin" != flathub
        continue
    end

    if not contains -- "$app" $wanted
        flatpak uninstall --assumeyes "$app"
    end
end
