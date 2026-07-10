if type -q rg
    function grep --wraps=rg --description 'Use ripgrep as grep'
        command rg $argv
    end
end

if type -q bat
    function cat --wraps=bat --description 'Use bat as cat'
        command bat $argv
    end
end

# if type -q fd
#     function find --wraps=fd --description 'Use fd as find'
#         command fd $argv
#     end
# end
#
# if type -q dust
#     function du --wraps=dust --description 'Use dust as du'
#         command dust $argv
#     end
# end
#
# if type -q procs
#     function ps --wraps=procs --description 'Use procs as ps'
#         command procs $argv
#     end
# end
#
# if type -q duf
#     function df --wraps=duf --description 'Use duf as df'
#         command duf $argv
#     end
# end
#
# if type -q btop
#     function top --wraps=btop --description 'Use btop as top'
#         command btop $argv
#     end
# end
