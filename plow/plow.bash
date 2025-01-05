#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

progname="$0"

error() {
  local line
  for line in "$@"; do
    echo "$progname: $line" 1>&2
  done

  exit 1
}

shopt -s nullglob globstar

if [[ ! -v PLOW_CACHE ]]; then
  PLOW_CACHE=.plowcache
fi

args=$(
  getopt \
    --options f:t:Fivm: \
    --longoptions from:,to:,force,interactive,verbose,directory-mode: \
    --name "$0" \
    -- "$@"
)

eval set -- "$args"

from=${PLOW_FROM:-$PWD}
to=${PLOW_TO:-$HOME}
lnflags=()
mkdirflags=()
rmflags=()
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
    rmflags+=(--force)
    shift
    ;;
  -i | --interactive)
    lnflags+=(--interactive)
    rmflags+=(--interactive)
    shift
    ;;
  -v | --verbose)
    lnflags+=(--verbose)
    mkdirflags+=(--verbose)
    rmflags+=(--verbose)
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

from=$(realpath --strip -- "$from")
to=$(realpath --strip -- "$to")

if (( $# > 0 )); then
  choices=("$@")
else
  choices=()
  for dir in "$from"/*/; do
    choices+=("$(basename -- "$dir")")
  done
fi

shopt -s dotglob

cache=()
if [[ -n "$PLOW_CACHE" ]]; then
  if [[ -e "$PLOW_CACHE" ]]; then
    while IFS= read -r link; do
      cache+=("$link")
    done < "$PLOW_CACHE"
  fi

  : > "$PLOW_CACHE"
fi

for choice in "${choices[@]}"; do
  prefix=$from/$choice
  for target in "$prefix"/**/*; do
    if [[ -f "$target" ]]; then
      link=$to${target#"$prefix"}
      parent=$(dirname -- "$link")
      mkdir --parents "${mkdirflags[@]}" -- "$parent"
      ln --symbolic "${lnflags[@]}" -- "$target" "$link"
      if [[ -n "$PLOW_CACHE" ]]; then
        echo "$link" >> "$PLOW_CACHE"
      fi
    fi
  done
done

for link in "${cache[@]}"; do
  if [[ -L "$link" && ! -f "$link" ]]; then
    rm "${rmflags[@]}" -- "$link"
  fi
done
