#!/usr/bin/env bash
# This script links your clone into /usr/local, so you can keep the .git
# directory out of the way.

mode=$1
if [[ -z $mode ]]; then
    mode="install"
fi

source_base=`pwd`

if [[ $mode == install ]]; then
    # Ensure that the Cellar exists
    if [[ ! -e "$source_base/Cellar" ]] ; then
        mkdir -p "$source_base/Cellar"
    fi
    
    if [[ ! -e "/usr/local/bin" ]] ; then
        mkdir -p /usr/local/bin
    fi
    
    ln -s "$source_base/bin/brew" "/usr/local/bin/brew";
    ln -s "$source_base/Library" "/usr/local/Library";
    ln -s "$source_base/Cellar" "/usr/local/Cellar";
elif [[ $mode == undo ]]; then
    if [[ -h "/usr/local/bin/brew" ]] ; then
        rm "/usr/local/bin/brew"
    fi

    if [[ -h "/usr/local/Library" ]] ; then
        rm "/usr/local/Library"
    fi

    if [[ -h "/usr/local/Cellar" ]] ; then
        rm "/usr/local/Cellar"
    fi
else
    echo "Unknown command: $mode";
    echo "\tselflink.sh [install] >> symlinks to /usr/local"
    echo "\tselflink.sh undo >> removes symlinks from /usr/local"
fi
