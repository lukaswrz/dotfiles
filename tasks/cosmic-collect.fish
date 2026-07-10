#!/usr/bin/env fish

function show_help
    echo "Usage: $(status filename) -t <to>"
    echo
    echo "Options:"
    echo "  -f, --from     Source config directory (default: ~)"
    echo "  -t, --to       Destination directory (required)"
    echo "  -v, --verbose  Verbose output"
    echo "  -h, --help     Print this help message"
end

argparse 'f/from=' 't/to=' v/verbose h/help -- $argv
or begin
    show_help >&2
    exit 1
end

set from ~
if set -q _flag_f
    set from (realpath --strip -- $_flag_f)
end

if not set -q _flag_t
    echo "Error: --to is required" >&2
    show_help >&2
    exit 1
end

set to $_flag_t

set mkdirflags
set lnflags

if set -q _flag_v
    set -a mkdirflags --verbose
    set -a lnflags --verbose
end

if set -q _flag_h
    show_help >&2
    exit 0
end

set cosmic $from/.config/cosmic

set excluded \
    $cosmic/com.system76.CosmicAppList/v1/favorites \
    $cosmic/com.system76.CosmicAppletTime/v1/first_day_of_week \
    $cosmic/com.system76.CosmicBackground/v1/all \
    $cosmic/com.system76.CosmicBackground/v1/backgrounds \
    $cosmic/com.system76.CosmicBackground/v1/output.* \
    $cosmic/com.system76.CosmicBackground/v1/same-on-all \
    $cosmic/com.system76.CosmicComp/v1/input_default \
    $cosmic/com.system76.CosmicComp/v1/xkb_config \
    $cosmic/com.system76.CosmicFiles/v1/tab \
    $cosmic/com.system76.CosmicPortal/v1/screenshot \
    $cosmic/com.system76.CosmicSettings.Wallpaper/v1/current-folder \
    $cosmic/com.system76.CosmicSettings.Wallpaper/v1/custom-images \
    $cosmic/com.system76.CosmicSettings.Wallpaper/v1/recent-folders

for file in $cosmic/**
    if test -d $file
        continue
    end

    if contains -- $file $excluded
        continue
    end

    set escaped_from (string escape --style regex -- $from)
    set target (realpath --strip -- $to/(string replace --regex -- "^$escaped_from" '' $file))
    mkdir --parents $mkdirflags -- (dirname -- $target)
    ln --force $lnflags -- $file $target
end
