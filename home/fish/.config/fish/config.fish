if status is-interactive
    stty -ixon

    set fish_greeting

    fish_vi_key_bindings

    bind \ee edit_command_buffer

    set fish_cursor_default block blink
    set fish_cursor_insert line blink
    set fish_cursor_replace_one underscore blink
    set fish_cursor_visual block

    if set -q XDG_CONFIG_HOME
        set -x RIPGREP_CONFIG_PATH $XDG_CONFIG_HOME/ripgrep/ripgreprc
    else
        set -x RIPGREP_CONFIG_PATH ~/.config/ripgrep/ripgreprc
    end

    if type -q direnv
        direnv hook fish | source
    end

    if type -q starship
        starship init fish | source
    end

    if type -q nix
        fish_add_path ~/.local/state/nix/profile/bin
    end

    abbr --add l ls
    abbr --add lsa ls -a
    abbr --add la ls -a
    abbr --add lsl ls -l
    abbr --add ll ls -l
    abbr --add lsla ls -la
    abbr --add lla ls -la

    abbr --add cp cp -n
    abbr --add cpr cp -rn

    abbr --add mv mv -n

    abbr --add rmr rm -r
    abbr --add rr rm -r

    abbr --add v hx

    abbr --add g git
    abbr --add gc git commit
    abbr --add gco git checkout
    abbr --add gs git status
    abbr --add gd git diff
    abbr --add ga git add

    abbr --add s sudo

    abbr --add gn grep -n
    abbr --add gin grep -in
    abbr --add grin grep -rin

    abbr --add df df -h

    abbr --add du du -h

    abbr --add c cd
end
