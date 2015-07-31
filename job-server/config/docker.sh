# Docker environment vars
# NOTE: only static vars not intended to be changed by users should appear here, because
#       this file gets sourced in the middle of server_start.sh, so it will override
#       any env vars set in the docker run command line.
PIDFILE=spark-jobserver.pid
SPARK_HOME=/spark
SPARK_CONF_DIR=$SPARK_HOME/conf
# For Docker, always run start script as foreground
JOBSERVER_FG=1
