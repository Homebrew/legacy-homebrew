#!/bin/bash
# Script for packaging all the job server files to .tar.gz for Mesos or other single-image deploys
WORK_DIR=/tmp/job-server

ENV=$1
if [ -z "$ENV" ]; then
  echo "Syntax: $0 <Environment>"
  echo "   for a list of environments, ls config/*.sh"
  exit 0
fi

bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin"; pwd`

if [ -z "$CONFIG_DIR" ]; then
  CONFIG_DIR=`cd "$bin"/../config/; pwd`
fi
configFile="$CONFIG_DIR/$ENV.sh"

if [ ! -f "$configFile" ]; then
  echo "Could not find $configFile"
  exit 1
fi
. $configFile

majorRegex='([0-9]+\.[0-9]+)\.[0-9]+'
if [[ $SCALA_VERSION =~ $majorRegex ]]
then
  majorVersion="${BASH_REMATCH[1]}"
else
  echo "Please specify SCALA_VERSION in ${configFile}"
  exit 1
fi

echo Packaging job-server for environment $ENV...

cd $(dirname $0)/..
sbt ++$SCALA_VERSION job-server-extras/assembly
if [ "$?" != "0" ]; then
  echo "Assembly failed"
  exit 1
fi

FILES="job-server-extras/target/scala-$majorVersion/spark-job-server.jar
       bin/server_start.sh
       bin/server_stop.sh
       $CONFIG_DIR/$ENV.conf
       config/log4j-server.properties"

rm -rf $WORK_DIR
mkdir -p $WORK_DIR
cp $FILES $WORK_DIR/
cp $configFile $WORK_DIR/settings.sh
pushd $WORK_DIR
TAR_FILE=$WORK_DIR/job-server.tar.gz
rm -f $TAR_FILE
tar zcvf $TAR_FILE *
popd

echo "Created distribution at $TAR_FILE"
