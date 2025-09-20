if status is-interactive
    stty -ixon

    set fish_greeting

    fish_vi_key_bindings

    bind \ee edit_command_buffer

    set fish_cursor_default block blink
    set fish_cursor_insert line blink
    set fish_cursor_replace_one underscore blink
    set fish_cursor_visual block

    begin
        set --local parent $XDG_CONFIG_HOME
        test -z $parent && set parent ~/.config
        set --export RIPGREP_CONFIG_PATH $parent/ripgrep/ripgreprc
    end

    if type -q direnv
        direnv hook fish | source
    end

    if type -q starship
        starship init fish | source
    end

    if type -q nix
        set --local parent $XDG_STATE_HOME
        test -z $parent && set parent ~/.local/state
        fish_add_path $parent/nix/profile/bin
    end

    if type -q hx
        set --export EDITOR hx
        set --export VISUAL hx
    end

    fish_add_path ~/.local/bin
end
