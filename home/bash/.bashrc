# shellcheck shell=bash

for rc in /etc/bashrc /etc/*.bashrc; do
  if [[ -e $rc ]]; then
    # shellcheck disable=SC1090
    source "$rc"
  fi
done
