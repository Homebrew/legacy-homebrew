#!/bin/bash
# Script to start the job server
# Extra arguments will be spark-submit options, for example
#  ./server_start.sh --jars cassandra-spark-connector.jar
#
# Environment vars (note settings.sh overrides):
#   JOBSERVER_MEMORY - defaults to 1G, the amount of memory (eg 512m, 2G) to give to job server
#   JOBSERVER_CONFIG - alternate configuration file to use
#   JOBSERVER_FG    - launches job server in foreground; defaults to forking in background
set -e

get_abs_script_path() {
  pushd . >/dev/null
  cd $(dirname $0)
  appdir=$(pwd)
  popd  >/dev/null
}

get_abs_script_path

GC_OPTS="-XX:+UseConcMarkSweepGC
         -verbose:gc -XX:+PrintGCTimeStamps -Xloggc:$appdir/gc.out
         -XX:MaxPermSize=512m
         -XX:+CMSClassUnloadingEnabled "

# To truly enable JMX in AWS and other containerized environments, also need to set
# -Djava.rmi.server.hostname equal to the hostname in that environment.  This is specific
# depending on AWS vs GCE etc.
JAVA_OPTS="-XX:MaxDirectMemorySize=512M \
           -XX:+HeapDumpOnOutOfMemoryError -Djava.net.preferIPv4Stack=true \
           -Dcom.sun.management.jmxremote.port=9999 \
           -Dcom.sun.management.jmxremote.rmi.port=9999 \
           -Dcom.sun.management.jmxremote.authenticate=false \
           -Dcom.sun.management.jmxremote.ssl=false"

MAIN="spark.jobserver.JobServer"

if [ -f "$JOBSERVER_CONFIG" ]; then
  conffile="$JOBSERVER_CONFIG"
else
  conffile=$(ls -1 $appdir/*.conf | head -1)
  if [ -z "$conffile" ]; then
    echo "No configuration file found"
    exit 1
  fi
fi

if [ -f "$appdir/settings.sh" ]; then
  . $appdir/settings.sh
else
  echo "Missing $appdir/settings.sh, exiting"
  exit 1
fi

if [ -z "$SPARK_HOME" ]; then
  echo "Please set SPARK_HOME or put it in $appdir/settings.sh first"
  exit 1
fi

pidFilePath=$appdir/$PIDFILE

if [ -f "$pidFilePath" ] && kill -0 $(cat "$pidFilePath"); then
   echo 'Job server is already running'
   exit 1
fi

if [ -z "$LOG_DIR" ]; then
  LOG_DIR=/tmp/job-server
  echo "LOG_DIR empty; logging will go to $LOG_DIR"
fi
mkdir -p $LOG_DIR

LOGGING_OPTS="-Dlog4j.configuration=file:$appdir/log4j-server.properties
              -DLOG_DIR=$LOG_DIR"

# For Mesos
CONFIG_OVERRIDES=""
if [ -n "$SPARK_EXECUTOR_URI" ]; then
  CONFIG_OVERRIDES="-Dspark.executor.uri=$SPARK_EXECUTOR_URI "
fi
# For Mesos/Marathon, use the passed-in port
if [ "$PORT" != "" ]; then
  CONFIG_OVERRIDES+="-Dspark.jobserver.port=$PORT "
fi

if [ -z "$JOBSERVER_MEMORY" ]; then
	JOBSERVER_MEMORY=1G
fi

# This needs to be exported for standalone mode so drivers can connect to the Spark cluster
export SPARK_HOME
export YARN_CONF_DIR
export HADOOP_CONF_DIR

cmd='$SPARK_HOME/bin/spark-submit --class $MAIN --driver-memory $JOBSERVER_MEMORY
  --conf "spark.executor.extraJavaOptions=$LOGGING_OPTS"
  --driver-java-options "$GC_OPTS $JAVA_OPTS $LOGGING_OPTS $CONFIG_OVERRIDES"
  $@ $appdir/spark-job-server.jar $conffile'
if [ -z "$JOBSERVER_FG" ]; then
  eval $cmd 2>&1 &
  echo $! > $pidFilePath
else
  eval $cmd
fi
