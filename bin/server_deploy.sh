#!/bin/bash
# Script for deploying the job server to a host
ENV=$1
if [ -z "$ENV" ]; then
  echo "Syntax: $0 <Environment>"
  echo "   for a list of environments, ls config/*.sh"
  exit 0
fi

if [ -z "$CONFIG_DIR" ]; then
  CONFIG_DIR="$(dirname $0)/config"
fi
configFile="$CONFIG_DIR/$ENV.sh"
if [ ! -f "$configFile" ]; then
  echo "Could not find $configFile"
  exit 1
fi
. $configFile

echo Deploying job server to $DEPLOY_HOSTS...

cd $(dirname $0)/..
sbt job-server/assembly
if [ "$?" != "0" ]; then
  echo "Assembly failed"
  exit 1
fi

FILES="job-server/target/spark-job-server.jar
       bin/server_start.sh
       bin/server_stop.sh
       $CONFIG_DIR/$ENV.conf
       config/log4j-server.properties"

for host in $DEPLOY_HOSTS; do
  # We assume that the deploy user is APP_USER and has permissions
  ssh ${APP_USER}@$host mkdir -p $INSTALL_DIR
  scp $FILES ${APP_USER}@$host:$INSTALL_DIR/
  scp $configFile ${APP_USER}@$host:$INSTALL_DIR/settings.sh
done
