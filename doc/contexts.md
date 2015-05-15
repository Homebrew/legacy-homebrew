## Custom Contexts and Context-specific Jobs

With Spark Jobserver 0.5.0, jobs no longer have to share just a plain
`SparkContext`, but can share other types of contexts as well, such as a
`SQLContext` or `HiveContext`.  This allows Spark jobs to share the state of 
other contexts, such as SQL temporary tables.  An example can be found in the 
`SQLLoaderJob` class, which creates a temporary table, and the `SQLTestJob` job, 
which runs a SQL query against the loaded table.  This feature can also be 
used with other contexts than the ones supplied by Spark itself, such as the 
CassandraContext from Datastax's Cassandra Spark Connector.

## Example

NOTE: To run these examples, we recommend you run `bin/server_package.sh`, edit
`/tmp/job-server/settings.sh` to point at your local Spark repo (with binaries
built), then run `/tmp/job-server/server_start.sh`.  The other option is to do
`project job-server-extras` then `reStart`, but due to
[SPARK-5281](https://issues.apache.org/jira/browse/SPARK-5281), you will hit an
error `scala.reflect.internal.MissingRequirementError` with running SQLContext
jobs.  This issue should be resolved in Spark 1.4.

To run jobs for a specific type of context, first you need to start a context with the `context-factory` param:

    curl -d "" '127.0.0.1:8090/contexts/sql-context?context-factory=spark.jobserver.context.SQLContextFactory'
    OK⏎

Similarly, to use a HiveContext for jobs pass `context-factory=spark.jobserver.context.HiveContextFactory`

Now you should be able to run jobs in that context:

    curl -d "" '127.0.0.1:8090/jobs?appName=test&classPath=spark.jobserver.SqlLoaderJob&context=sql-context&sync=true'

NOTE: you will get an error if you run the wrong type of job, such as a regular SparkJob in a `SQLContext`.

## Extending Job Server for Custom Contexts

This can be done easily by extending the `SparkContextFactory` trait, like `SQLContextFactory` does.  Then, extend the `SparkJobBase` trait in a job with a type matching your factory.

## Jars

If you wish to use the `SQLContext` or `HiveContext`, be sure to pull down the job-server-extras package.