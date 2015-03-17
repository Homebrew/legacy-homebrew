#!/bin/bash
# Script to stop the job server

get_abs_script_path() {
  pushd . >/dev/null
  cd $(dirname $0)
  appdir=$(pwd)
  popd  >/dev/null
}

get_abs_script_path

if [ -f "$appdir/settings.sh" ]; then
  . $appdir/settings.sh
else
  echo "Missing $appdir/settings.sh, exiting"
  exit 1
fi

pidFilePath=$appdir/$PIDFILE

if [ ! -f "$pidFilePath" ] || ! kill -0 $(cat "$pidFilePath"); then
   echo 'Job server not running'
else
  echo 'Stopping job server...'
  kill -15 $(cat "$pidFilePath") && rm -f "$pidFilePath"
  echo '...job server stopped'
fi
