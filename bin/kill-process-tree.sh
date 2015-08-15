#!/bin/bash

if [ "$(which pgrep)" == "" ]; then
    echo "pgrep is not available" >&2
    exit 1
fi

if [ "$#" != "2" ]; then
    echo "Syntax error, the expected usage is: kill-process-tree <signal> <process_id>" >&2
    exit 1
fi

# This simple script allows to kill the whole process tree. The first argument is a signal and the second
# is the root process
parent=$2
signal=$1

# A string which will be populated with descendant processes ids
pids="$parent"

# Kills the given process if it is running. It also checks whether the given parameter contains process ID
function kill_if_running() {
    if [[ "$1" =~ [0-9]+ ]]; then
        ps -e -o pid= | grep $1 > /dev/null
        if [ $? -eq 0 ]; then
            kill "-$signal" "$1"
            return 0
        else
            return 1
        fi
    fi
}

# Populates pids with descendant processes ids
function get_descendants_pids() {
    for cpid in $(pgrep -P $1);
    do
        pids="$cpid $pids"
        get_descendants_pids $cpid
    done
}

get_descendants_pids $parent

for pid in $pids
do
    if [ "$signal" == "" ]; then
        echo "$pid"
    else
        kill_if_running $pid
        if [ $? -eq 0 ]; then
            # If the process has been really killed, then wait for 3 seconds before going to the next
            # process. In most cases, where there is a scripts execution hierarchy with Java process
            # at the bottom, it is sufficient to kill that Java process and the scripts will just exit
            # in a natural way
            echo "Sent $signal to $pid, sleeping for 3 seconds"
            sleep 3s
        fi
    fi
done