#!/bin/bash
# Script for setting up folders for job server deployment
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

echo Setting up ${DEPLOY_HOSTS}...

for host in $DEPLOY_HOSTS; do
  ssh root@${host} mkdir -p $INSTALL_DIR
  ssh root@${host} chown ${APP_USER}:${APP_GROUP} $INSTALL_DIR
  ssh root@${host} mkdir -p $LOG_DIR
  ssh root@${host} chown ${APP_USER}:${APP_GROUP} $LOG_DIR
done
