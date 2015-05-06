## Configuring Job Server for YARN

(Looking for contributors for this page)

(I would like to thank Jon Buffington for sharing the config tips below.... @velvia)

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

It was trial and error to find the best memory-per-node setting. If you over allocate memory per node, YARN will not allocate the expected executors.
