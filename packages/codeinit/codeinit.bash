#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

extensions=(
    anishde12020.orbi
    jnoortheen.nix-ide
    llvm-vs-code-extensions.vscode-clangd
    mkhl.direnv
    phpactor.vscode-phpactor
    rust-lang.rust-analyzer
    tamasfe.even-better-toml
    vscodevim.vim
    xdebug.php-debug
    "$@"
)

if ! hash codium; then
    exit 1
fi

args=()
for ext in "${extensions[@]}"; do
    args+=(--install-extension "$ext")
done

codium "${args[@]}"
