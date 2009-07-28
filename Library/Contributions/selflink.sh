#!/usr/bin/env bash

mode=$1
if [[ -z $mode ]]; then
    mode="install"
fi

source_base=`pwd`

if [[ $mode == install ]]; then
    ln -s "$source_base/bin/brew" "/usr/local/bin/brew";
    ln -s "$source_base/Library" "/usr/local/Library";
    ln -s "$source_base/Cellar" "/usr/local/Cellar";
elif [[ $mode == undo ]]; then 
    rm "/usr/local/bin/brew"
    rm "/usr/local/Library"
    rm "/usr/local/Cellar"
else
    echo "Unknown command: $mode";
    echo "\tselflink.sh [install] >> symlinks to /usr/local"
    echo "\tselflink.sh undo >> removes symlinks from /usr/local"
fi
