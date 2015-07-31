# Docker

Spark-jobserver is available as a Docker container!  This might be the easiest way to get started and deploy.

To get started:

    docker run -d -p 8090:8090 velvia/spark-jobserver:0.5.2-SNAPSHOT

This will start job server on port 8090 in a container, with H2 database and Mesos support, and expose that port to the host on which you run the container.

If you would like to debug job server using JMX / VisualVM etc., then also expose port 9999.

## Configuration

By default, the container has an embedded Spark distro and runs using Spark local mode (`local[4]`).

To change the spark master the container runs against, set SPARK_MASTER when you start the container:

    docker run -d -p 8090:8090 -e SPARK_MASTER=mesos://zk://mesos.master:5050 velvia/spark-jobserver:0.5.2-SNAPSHOT

You can easily change the amount of memory job server uses with `JOBSERVER_MEMORY`, or replace the entire config job server uses at startup with `JOBSERVER_CONFIG`.

The standard way to replace the config is to derive a custom Docker image from the job server one by overwriting the default config at `app/docker.conf`.  The Dockerfile would look like this:

    from velvia/spark-jobserver:0.5.2-SNAPSHOT
    add /path/to/my/jobserver.conf /app/docker.conf

Similarly, to change the logging configuration, inherit from this container and overwrite `/app/log4j-server.properties`.

## Jars / Passing Arguments to the Start Script

Any `spark-submit` arguments can be passed to the tail of the `docker run` command.  A very common use of this is to add custom jars to your Spark job environment.  For example, to add the Datastax Spark-Cassandra Connector to your job:

    docker run -d -p 8090:8090 velvia/spark-jobserver:0.5.2-SNAPSHOT --packages com.datastax.spark:spark-cassandra-connector_2.10:1.3.0-M1

## Database, Persistence, Logs

Docker containers are usually stateless, but it wouldn't be very useful to have the jars and job config reset every time you had to kill and restart a container.

The job server docker image is configured to use H2 database by default and to write the database to a Docker volume at `/database`, which will be persisted between container restarts, and can even be shared amongst multiple job server containers on the same host. Note that in order to persist them to new containers, you need to create a local directory, something like this:

    docker run -d -p 8090:8090 -v /opt/job-server-db:/database velvia/spark-jobserver:0.5.2-SNAPSHOT

See the [Docker Volumes Guide](http://docs-stage.docker.com/userguide/dockervolumes/#volume) for more info.

Another option is to configure job server to persist metadata in PostGres, MySQL, or similar database.  To do that, create a new config, pass it into the docker container as above using `JOBSERVER_CONFIG` and the `/config` volume, and point to your shared database, perhaps using `--link` to a PostGres or MySQL container.

Logging goes to stdout, as per standard Docker conventions.  Therefore:

* Use `docker logs -f <containerHash>` to follow logs
* Use `docker logs --tail=100 <containerHash>` to list the last 100 lines
* Use Docker logging drivers to redirect logs to syslog, SumoLogic, etc.

## Marathon