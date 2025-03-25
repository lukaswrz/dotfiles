# shellcheck shell=bash

shopt -s autocd globstar nullglob extglob checkwinsize

for rc in /etc/bashrc /etc/*.bashrc; do
  if [[ -e $rc ]]; then
    # shellcheck disable=SC1090
    source "$rc"
  fi
done

if hash direnv 2>/dev/null; then
  eval "$(direnv hook bash)"
fi

if hash starship 2>/dev/null; then
  eval "$(starship init bash)"
fi

if hash nix 2>/dev/null; then
  export PATH=${XDG_STATE_HOME:-~/.local/state}/nix/profile/bin:$PATH
fi

if hash hx 2>/dev/null; then
  export EDITOR=hx
  export VISUAL=hx
fi

export PATH=~/.local/bin:$PATH
