shopt -s autocd globstar nullglob extglob checkwinsize

for rc in /etc/bashrc /etc/*.bashrc; do
  if [[ -e $rc ]]; then
    source "$rc"
  fi
done
