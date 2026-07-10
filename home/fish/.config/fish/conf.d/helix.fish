if type -q hx
    set -x EDITOR hx
    set -x VISUAL hx

    function n --wraps hx --description 'Take a note'
        set -l notes ~/Notes
        mkdir --parents -- $notes
        cd -- $notes
        hx $argv
    end
end
