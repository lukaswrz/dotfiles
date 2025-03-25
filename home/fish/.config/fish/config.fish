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
