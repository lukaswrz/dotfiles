set -o errexit
set -o nounset
set -o pipefail

shopt -s nullglob globstar

opts=$(getopt --options f:t:Fivm: --longoptions=from:,to:,force,interactive,verbose,directory-mode: --name "$0" -- "$@")

eval set -- "$opts"

from=$PWD
to=$HOME
lnflags=()
mkdirflags=()
while true; do
  case "$1" in
  -f | --from)
    from=$2
    shift 2
    ;;
  -t | --to)
    to=$2
    shift 2
    ;;
  -F | --force)
    lnflags+=(--force)
    shift
    ;;
  -i | --interactive)
    lnflags+=(--interactive)
    shift
    ;;
  -v | --verbose)
    lnflags+=(--verbose)
    mkdirflags+=(--verbose)
    shift
    ;;
  -m | --directory-mode)
    mkdirflags+=(--mode "$2")
    shift 2
    ;;
  --)
    shift
    break
    ;;
  esac
done

if (( $# > 0 )); then
  choices=("$@")
else
  choices=()
  for dir in "$from"/*/; do
    choices+=("$(basename -- "$dir")")
  done
fi

shopt -s dotglob

for choice in "${choices[@]}"; do
  prefix=$from/$choice
  for target in "$prefix"/**/*; do
    if [[ -f "$target" ]]; then
      link=$to${target#"$prefix"}
      mkdir --parents "${mkdirflags[@]}" -- "$(dirname -- "$link")"
      ln --symbolic "${lnflags[@]}" -- "$target" "$link"
    fi
  done
done
