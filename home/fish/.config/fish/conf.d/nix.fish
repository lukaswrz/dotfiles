if type -q nix
    set -l parent $XDG_STATE_HOME
    test -z $parent && set parent ~/.local/state
    fish_add_path $parent/nix/profile/bin
end
