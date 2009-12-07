#!/usr/bin/env bash
# This script links your clone into $install_base, so you can keep the .git
# directory out of the way. Default for no parameters is /usr/local

mode=$1
if [[ -z $mode ]]; then
    mode="install"
fi

install_base=$2
if [[ -z $install_base ]]; then
    install_base="/usr/local"
fi

source_base=`pwd`

if [[ $mode == install ]]; then
    # Ensure that the Cellar exists -- otherwise Homebrew breaks
    if [[ ! -e "$source_base/Cellar" ]] ; then
        mkdir -p "$source_base/Cellar"
    fi
    
    if [[ ! -e "$install_base/bin" ]] ; then
        mkdir -p $install_base/bin
    fi
    
    ln -s "$source_base/bin/brew" "$install_base/bin/brew";
    ln -s "$source_base/Library" "$install_base/Library";
    ln -s "$source_base/Cellar" "$install_base/Cellar";
elif [[ $mode == undo ]]; then
    if [[ -h "$install_base/bin/brew" ]] ; then
        rm "$install_base/bin/brew"
    fi

    if [[ -h "$install_base/Library" ]] ; then
        rm "$install_base/Library"
    fi

    if [[ -h "$install_base/Cellar" ]] ; then
        rm "$install_base/Cellar"
    fi
else
    echo "Unknown command: $mode";
    echo "\tselflink.sh [install] >> symlinks to $install_base"
    echo "\tselflink.sh undo >> removes symlinks from $install_base"
fi
