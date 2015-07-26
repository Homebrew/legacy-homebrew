# Docker environment vars
LOG_DIR=/var/log/job-server
PIDFILE=spark-jobserver.pid
# DRIVER_MEMORY=2G
JOBSERVER_MEMORY=512m
SPARK_HOME=/usr/local/spark
SPARK_CONF_DIR=$SPARK_HOME/conf
# For Docker, always run start script as foreground
JOBSERVER_FG=1
