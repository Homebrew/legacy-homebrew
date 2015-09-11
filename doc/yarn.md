## Configuring Job Server for YARN

(Looking for contributors for this page)

(I would like to thank Jon Buffington for sharing the config tips below.... @velvia)

### Configuring the Spark-Jobserver Docker package to run in Yarn-Client Mode

To run the Spark-Jobserver in yarn-client mode you have to do a little bit extra of configuration.
You can either follow the instructions here for a little bit of explanations or check out the [example repository](https://github.com/MeiSign/spark-jobserver-yarn-client-example) and adjust it to your needson your own.
First of all make sure that your have a correct docker installation on the host that shall run the spark-jobserver.

I suggest you to create a new directory for your custom config files.

Files we need:
- docker.conf
- dockerfile
- cluster-config directory with hdfs-site.xml and yarn-site.xml (You should have these files already)

Example docker.conf (important settings are marked with # important):

    spark {
      master = "yarn-client" # important
      master = ${?SPARK_MASTER}
    
      # Default # of CPUs for jobs to use for Spark standalone cluster
      job-number-cpus = 4

      jobserver {
        port = 8090
        jobdao = spark.jobserver.io.JobSqlDAO

        sqldao {
          # Directory where default H2 driver stores its data. Only needed for H2.
          rootdir = /database

          # Full JDBC URL / init string.  Sorry, needs to match above.
          # Substitutions may be used to launch job-server, but leave it out here in the default or tests won't pass
          jdbc.url = "jdbc:h2:file:/database/h2-db"
        }
      }

      # predefined Spark contexts
      # contexts {
      #   my-low-latency-context {
      #     num-cpu-cores = 1           # Number of cores to allocate.  Required.
      #     memory-per-node = 512m         # Executor memory per node, -Xmx style eg 512m, 1G, etc.
      #   }
      #   # define additional contexts here
      # }

      # universal context configuration.  These settings can be overridden, see README.md
      context-settings {
        # choose a port that is free on your system and also the 16 (depends on max retries for submitting the job) next portnumbers should be free 
        spark.driver.port = 32456 # important
        # defines the place where your spark-assembly jar is located in your hdfs
        spark.yarn.jar = "hdfs://hadoopHDFSCluster/spark_jars/spark-assembly-1.4.1-hadoop2.6.0.jar" # important

        num-cpu-cores = 2           # Number of cores to allocate.  Required.
        memory-per-node = 512m         # Executor memory per node, -Xmx style eg 512m, #1G, etc.
    
        # in case spark distribution should be accessed from HDFS (as opposed to being installed on every mesos slave)
        # spark.executor.uri = "hdfs://namenode:8020/apps/spark/spark.tgz"

        # uris of jars to be loaded into the classpath for this context. Uris is a string list, or a string separated by commas ','
        # dependent-jar-uris = ["file:///some/path/present/in/each/mesos/slave/somepackage.jar"]

        # If you wish to pass any settings directly to the sparkConf as-is, add them here in passthrough,
        # such as hadoop connection settings that don't use the "spark." prefix
        passthrough {
          #es.nodes = "192.1.1.1"
        }
      }

      # This needs to match SPARK_HOME for cluster SparkContexts to be created successfully
      home = "/usr/local/spark"
    }

Now that we have a docker.conf that should work we can create our dockerfile to create a docker container:

dockerfile:

    FROM velvia/spark-jobserver:0.5.2
    EXPOSE 32456-32472                                    # Expose driver port range (spark.driver.port + 16)
    ADD /path/to/your/docker.conf /app/docker.conf        # Add the docker.conf to the container
    ADD /path/to/your/cluster-config /app/cluster-config  # Add the yarn-site.xml and hfds-site.xml to the container
    ENV YARN_CONF_DIR=/app/cluster-config                 # Set env variables for spark
    ENV HADOOP_CONF_DIR=/app/cluster-config               # Set env variables for spark
    
Your dockercontainer is now ready to be build:
    
    docker build -t=your-container-name /directory/with/your/dockerfile

Output should look like this:

    Sending build context to Docker daemon  21.5 kB
    Step 0 : FROM velvia/spark-jobserver:0.5.2
     ---> a41dbd362a7d
    Step 1 : EXPOSE 32456-32472
     ---> f1c91bbaa2d8
    Step 2 : ADD ./docker.conf /app/docker.conf
     ---> c7c983e279e3
    Step 3 : ADD ./cluster-config /app/cluster-config
     ---> 684951fb6bec
    Step 4 : ENV YARN_CONF_DIR /app/cluster-config
     ---> 2f4cbf17443a
    Step 5 : ENV HADOOP_CONF_DIR /app/cluster-config
     ---> ca0460d53b28
    Successfully built ca0460d53b28

The last step to your jarn-client is to run the docker container that you have just created:

    docker run -d -p 8090:8090 -p 32456-32472:32456-32472 --net=host your-container-name
    
  The -p parameters are necessary to publish the ports for the rest interface and to communicate with the cluster.
  The --net parameter is necessary to make the docker container accessible from the spark cluster. I have found no way to do this in bridging mode (pullrequests appreciated).
  
Your Spark-Jobserver should now be up and running

### Important Context Settings for yarn

I recently responded to a private question about configuring job-server AWS EMR running Spark and wanted to share with the group.

We are successfully using job-server running on AWS EMR with Spark 1.3.0 in one case and 1.2.1 in another. We found that configuring the job-server app context correctly is critical to for Spark/YARN to maximize resources. For example, one of our clusters is composed of 4 slave r3.xlarge instances. The following snippet allowed us to create the expected number of executors with the most RAM:

```
...
contexts {
  shared {
    num-cpu-cores = 1 # shared tasks work best in parallel.
    memory-per-node = 4608M # trial-and-error discovered memory per node
    spark.executor.instances = 17 # 4 r3.xlarge instances with 4 cores each = 16 + 1 master
    spark.scheduler.mode = "FAIR"
    spark.scheduler.allocation.file = "/home/hadoop/spark/job-server/job_poolconfig.xml"
  }
}
...
```

It was trial and error to find the best memory-per-node setting. If you over allocate memory per node, YARN will not allocate the expected executors.
