# Troubleshooting

## Tests don't pass or have timeouts

If you used `reStart` to start a local job server, be sure it's stopped using `reStop` first.

## Job server won't start / cannot bind to 0.0.0.0:8090

Check that another process isn't already using that port.  If it is, you may want to start it on another port:

    reStart --- -Dspark.jobserver.port=2020

## Job Server Doesn't Connect to Spark Cluster

Finally, I got the problem solved. There are two problems in my configuration:
1. the version of spark cluster is 1.1 but the spark version in job server machine is 1.0.2
after upgrading spark to 1.1 in job server machine, jobs can be submitted to spark cluster (can show in spark UI) but cannot be executed.
2. the spark machines need to know the host name of job server machine
after this fixed, I can run jobs submitted from a remote job server successfully.

(Thanks to @pcliu)