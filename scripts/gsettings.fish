#!/usr/bin/env fish

for n in (seq 1 10)
    set --local kn (math $n % 10)

    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$n "['<Control><Alt>$kn']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-$n "['<Control><Alt><Shift>$kn']"
end
