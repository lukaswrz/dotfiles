status --is-interactive; or return

function default --description 'Prints the first value that is not empty'
    for val in $argv
        if test -z "$val"
            continue
        end

        echo -- $val
        return 0
    end

    return 1
end

# Disable flow control (XON/XOFF)
stty -ixon

# Cursor
set -g fish_cursor_default block blink
set -g fish_cursor_insert line blink
set -g fish_cursor_replace_one underscore blink
set -g fish_cursor_visual block

# Bindings
set -g fish_key_bindings fish_vi_key_bindings

# Disable greeting
set -g fish_greeting

# Direnv
if type -q direnv
    direnv hook fish | source
end

# SSH
if test -z "$SSH_ENV"
    set -xg SSH_ENV $HOME/.ssh/environment
end
if not __ssh_agent_is_started
    __ssh_agent_start
end

# Go
set -xg GOPATH (string join / (default $XDG_DATA_HOME "$HOME/.local/share") go)
set -xg GOMODCACHE (string join / (default $XDG_CACHE_HOME "$HOME/.cache") go mod)

# Editor
if type -q nextvi
    set -xg EDITOR nextvi
    set -xg VISUAL nextvi
    function n --wraps nextvi --description 'Take a note'
        set -l notes ~/Notes
        mkdir --parents -- $notes
        cd -- $notes
        nextvi $argv
    end

    function v --wraps nextvi
        nextvi $argv
    end
    function vi --wraps nextvi
        nextvi $argv
    end
    function vim --wraps nextvi
        nextvi $argv
    end
end

# Gram
if type -q gram
    function gram --wraps gram --description 'Open project in Gram'
        if test (count $argv) -eq 0
            exec gram .
        end

        command gram $argv
    end
end

# Nix
if type -q nix
    set -l parent $XDG_STATE_HOME
    test -z "$parent" && set parent ~/.local/state
    fish_add_path $parent/nix/profile/bin
end

# Ripgrep
if type -q rg
    function grep --wraps=rg --description 'Use ripgrep as grep'
        command rg $argv
    end
end

# Scripts
fish_add_path --append -- ~/.local/bin
