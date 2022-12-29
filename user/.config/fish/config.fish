if status is-interactive
  stty -ixon
  set -U fish_greeting
  fish_vi_key_bindings

  abbr --add --global l 'ls'
  abbr --add --global lsa 'ls -a'
  abbr --add --global la 'ls -a'
  abbr --add --global lsl 'ls -l'
  abbr --add --global ll 'ls -l'
  abbr --add --global lsla 'ls -la'
  abbr --add --global lla 'ls -la'
  abbr --add --global cp 'cp -n'
  abbr --add --global cpr 'cp -rn'
  abbr --add --global mv 'mv -n'
  abbr --add --global rm 'rm -i'
  abbr --add --global rmr 'rm -ri'
  abbr --add --global rr 'rm -ri'
  abbr --add --global v 'neovide'
  abbr --add --global g 'git'
  abbr --add --global gc 'git commit'
  abbr --add --global gco 'git checkout'
  abbr --add --global gs 'git status'
  abbr --add --global gd 'git diff'
  abbr --add --global gdh 'git diff HEAD'
  abbr --add --global ga 'git add'
  abbr --add --global s 'sudo'
  abbr --add --global g 'grep'
  abbr --add --global gn 'grep -n'
  abbr --add --global gin 'grep -in'
  abbr --add --global grin 'grep -rin'
  abbr --add --global df 'df -h'
  abbr --add --global du 'du -h'
  abbr --add --global c 'cd'
  abbr --add --global cd. 'cd .'
  abbr --add --global cd.. 'cd ..'

  function ls; command ls --classify=auto --color=auto --hyperlink=auto $argv; end
  function ffmpeg; command ffmpeg -hide_banner $argv; end
  function ffprobe; command ffprobe -hide_banner $argv; end
  function ffplay; command ffprobe -hide_banner $argv; end
end

if begin
  status is-login; and not set -q ZELLIJ
end; or begin
  set -q SSH_CLIENT; and set -q SSH_CONNECTION; and set -q SSH_TTY
end
  fish_add_path --prepend ~/.local/bin

  set -x SUDO_ASKPASS ~/.local/bin/askpassmenu
  set -x EDITOR nvim
  set -x VISUAL nvim

  set -x XDG_CONFIG_HOME "$HOME/.config"
  set -x XDG_CACHE_HOME "$HOME/.cache"
  set -x XDG_DATA_HOME "$HOME/.local/share"
end

if status is-login; and not set -q ZELLIJ; and not begin
  set -q SSH_CLIENT; or set -q SSH_CONNECTION; or set -q SSH_TTY
end
  if type -q sway
    if test (tty) = '/dev/tty1'
      begin
        swaywrap
      end
    end
  end
end
