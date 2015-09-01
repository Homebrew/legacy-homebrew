[![Build Status](https://travis-ci.org/spark-jobserver/spark-jobserver.svg?branch=master)](https://travis-ci.org/spark-jobserver/spark-jobserver)

[![Join the chat at https://gitter.im/spark-jobserver/spark-jobserver](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/spark-jobserver/spark-jobserver?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

spark-jobserver provides a RESTful interface for submitting and managing [Apache Spark](http://spark-project.org) jobs, jars, and job contexts.
This repo contains the complete Spark job server project, including unit tests and deploy scripts.
It was originally started at [Ooyala](http://www.ooyala.com), but this is now the main development repo.

See [Troubleshooting Tips](doc/troubleshooting.md) as well as [Yarn tips](doc/yarn.md).

## Users

(Please add yourself to this list!)

- Ooyala
- Netflix
- Avenida.com
- GumGum
- Fuse Elements
- Frontline Solvers
- Aruba Networks
- [Zed Worldwide](http://www.zed.com)
- [KNIME](https://www.knime.org/)

## Features

- *"Spark as a Service"*: Simple REST interface (including HTTPS) for all aspects of job, context management
- Support for Spark SQL, Hive, Streaming Contexts/jobs and custom job contexts!  See [Contexts](doc/contexts.md).
- Supports sub-second low-latency jobs via long-running job contexts
- Start and stop job contexts for RDD sharing and low-latency jobs; change resources on restart
- Kill running jobs via stop context and delete job
- Separate jar uploading step for faster job startup
- Asynchronous and synchronous job API.  Synchronous API is great for low latency jobs!
- Works with Standalone Spark as well as Mesos and yarn-client
- Job and jar info is persisted via a pluggable DAO interface
- Named RDDs to cache and retrieve RDDs by name, improving RDD sharing and reuse among jobs. 
- Supports Scala 2.10 and 2.11

## Version Information

| Version     | Spark Version |
|-------------|---------------|
| 0.3.1       | 0.9.1         |
| 0.4.0       | 1.0.2         |
| 0.4.1       | 1.1.0         |
| 0.5.0       | 1.2.0         |
| 0.5.1       | 1.3.0         |
| 0.5.2       | 1.3.1         |

For release notes, look in the `notes/` directory.  They should also be up on [ls.implicit.ly](http://ls.implicit.ly/spark-jobserver/spark-jobserver).

## Quick Start

The easiest way to get started is to try the [Docker container](doc/docker.md) which prepackages a Spark distribution with the job server and lets you start and deploy it.

## Development mode

The example walk-through below shows you how to use the job server with an included example job, by running the job server in local development mode in SBT.  This is not an example of usage in production.

You need to have [SBT](http://www.scala-sbt.org/release/docs/Getting-Started/Setup.html) installed.

To set the current version, do something like this:

    export VER=`sbt version | tail -1 | cut -f2`

From SBT shell, simply type "reStart".  This uses a default configuration file.  An optional argument is a
path to an alternative config file.  You can also specify JVM parameters after "---".  Including all the
options looks like this:

    reStart /path/to/my.conf --- -Xmx8g

Note that reStart (SBT Revolver) forks the job server in a separate process.  If you make a code change, simply
type reStart again at the SBT shell prompt, it will compile your changes and restart the jobserver.  It enables
very fast turnaround cycles.

**NOTE2**: You cannot do `sbt reStart` from the OS shell.  SBT will start job server and immediately kill it.

For example jobs see the job-server-tests/ project / folder.

When you use `reStart`, the log file goes to `job-server/job-server-local.log`.  There is also an environment variable
EXTRA_JAR for adding a jar to the classpath.

### WordCountExample walk-through

#### Package Jar - Send to Server
First, to package the test jar containing the WordCountExample: `sbt job-server-tests/package`.
Then go ahead and start the job server using the instructions above.

Let's upload the jar:

    curl --data-binary @job-server-tests/target/job-server-tests-$VER.jar localhost:8090/jars/test
    OK⏎

#### Ad-hoc Mode - Single, Unrelated Jobs (Transient Context)
The above jar is uploaded as app `test`.  Next, let's start an ad-hoc word count job, meaning that the job
server will create its own SparkContext, and return a job ID for subsequent querying:

    curl -d "input.string = a b c a b see" 'localhost:8090/jobs?appName=test&classPath=spark.jobserver.WordCountExample'
    {
      "status": "STARTED",
      "result": {
        "jobId": "5453779a-f004-45fc-a11d-a39dae0f9bf4",
        "context": "b7ea0eb5-spark.jobserver.WordCountExample"
      }
    }⏎

NOTE: If you want to feed in a text file config and POST using curl, you want the `--data-binary` option, otherwise
curl will munge your line separator chars.  Like:

    curl --data-binary @my-job-config.json 'localhost:8090/jobs?appNam=...'

From this point, you could asynchronously query the status and results:

    curl localhost:8090/jobs/5453779a-f004-45fc-a11d-a39dae0f9bf4
    {
      "status": "OK",
      "result": {
        "a": 2,
        "b": 2,
        "c": 1,
        "see": 1
      }
    }⏎

Note that you could append `&sync=true` when you POST to /jobs to get the results back in one request, but for
real clusters and most jobs this may be too slow.

You can also append `&timeout=XX` to extend the request timeout for `sync=true` requests.

#### Persistent Context Mode - Faster & Required for Related Jobs
Another way of running this job is in a pre-created context.  Start a new context:

    curl -d "" 'localhost:8090/contexts/test-context?num-cpu-cores=4&memory-per-node=512m'
    OK⏎

You can verify that the context has been created:

    curl localhost:8090/contexts
    ["test-context"]⏎

Now let's run the job in the context and get the results back right away:

    curl -d "input.string = a b c a b see" 'localhost:8090/jobs?appName=test&classPath=spark.jobserver.WordCountExample&context=test-context&sync=true'
    {
      "status": "OK",
      "result": {
        "a": 2,
        "b": 2,
        "c": 1,
        "see": 1
      }
    }⏎

Note the addition of `context=` and `sync=true`.

## Create a Job Server Project
In your `build.sbt`, add this to use the job server jar:

	resolvers += "Job Server Bintray" at "https://dl.bintray.com/spark-jobserver/maven"

	libraryDependencies += "spark.jobserver" %% "job-server-api" % "0.5.2" % "provided"

If a SQL or Hive job/context is desired, you also want to pull in `job-server-extras`:

    libraryDependencies += "spark.jobserver" %% "job-server-extras" % "0.5.2" % "provided"

For most use cases it's better to have the dependencies be "provided" because you don't want SBT assembly to include the whole job server jar.

To create a job that can be submitted through the job server, the job must implement the `SparkJob` trait. 
Your job will look like:
```scala
object SampleJob  extends SparkJob {
    override def runJob(sc:SparkContext, jobConfig: Config): Any = ???
    override def validate(sc:SparkContext, config: Config): SparkJobValidation = ???
}
```

- `runJob` contains the implementation of the Job. The SparkContext is managed by the JobServer and will be provided to the job through this method.
  This relieves the developer from the boiler-plate configuration management that comes with the creation of a Spark job and allows the Job Server to
manage and re-use contexts.
- `validate` allows for an initial validation of the context and any provided configuration. If the context and configuration are OK to run the job, returning `spark.jobserver.SparkJobValid` will let the job execute, otherwise returning `spark.jobserver.SparkJobInvalid(reason)` prevents the job from running and provides means to convey the reason of failure. In this case, the call immediately returns an `HTTP/1.1 400 Bad Request` status code.  
`validate` helps you preventing running jobs that will eventually fail due to missing or wrong configuration and save both time and resources.  

Let's try running our sample job with an invalid configuration:

    curl -i -d "bad.input=abc" 'localhost:8090/jobs?appName=test&classPath=spark.jobserver.WordCountExample'

    HTTP/1.1 400 Bad Request
    Server: spray-can/1.2.0
    Date: Tue, 10 Jun 2014 22:07:18 GMT
    Content-Type: application/json; charset=UTF-8
    Content-Length: 929

    {
      "status": "VALIDATION FAILED",
      "result": {
        "message": "No input.string config param",
        "errorClass": "java.lang.Throwable",
        "stack": ["spark.jobserver.JobManagerActor$$anonfun$spark$jobserver$JobManagerActor$$getJobFuture$4.apply(JobManagerActor.scala:212)", 
        "scala.concurrent.impl.Future$PromiseCompletingRunnable.liftedTree1$1(Future.scala:24)", 
        "scala.concurrent.impl.Future$PromiseCompletingRunnable.run(Future.scala:24)", 
        "akka.dispatch.TaskInvocation.run(AbstractDispatcher.scala:42)",
        "akka.dispatch.ForkJoinExecutorConfigurator$AkkaForkJoinTask.exec(AbstractDispatcher.scala:386)", 
        "scala.concurrent.forkjoin.ForkJoinTask.doExec(ForkJoinTask.java:260)", 
        "scala.concurrent.forkjoin.ForkJoinPool$WorkQueue.runTask(ForkJoinPool.java:1339)", 
        "scala.concurrent.forkjoin.ForkJoinPool.runWorker(ForkJoinPool.java:1979)", 
        "scala.concurrent.forkjoin.ForkJoinWorkerThread.run(ForkJoinWorkerThread.java:107)"]
      }
    }

### Using Named RDDs
Named RDDs are a way to easily share RDDs among job. Using this facility, computed RDDs can be cached with a given name and later on retrieved.
To use this feature, the SparkJob needs to mixin `NamedRddSupport`:
```scala
object SampleNamedRDDJob  extends SparkJob with NamedRddSupport {
    override def runJob(sc:SparkContext, jobConfig: Config): Any = ???
    override def validate(sc:SparkContext, config: Config): SparkJobValidation = ???
}
```

Then in the implementation of the job, RDDs can be stored with a given name:
```scala
this.namedRdds.update("french_dictionary", frenchDictionaryRDD)
```
Other job running in the same context can retrieve and use this RDD later on:
```scala
val rdd = this.namedRdds.get[(String, String)]("french_dictionary").get 
```
(note the explicit type provided to get. This will allow to cast the retrieved RDD that otherwise is of type RDD[_])

For jobs that depends on a named RDDs it's a good practice to check for the existence of the NamedRDD in the `validate` method as explained earlier:
```scala   
def validate(sc:SparkContext, config: Contig): SparkJobValidation = {
  ...
  val rdd = this.namedRdds.get[(Long, scala.Seq[String])]("dictionary")
  if (rdd.isDefined) SparkJobValid else SparkJobInvalid(s"Missing named RDD [dictionary]")
}
```

### HTTPS / SSL Configuration
To activate ssl communication, set these flags in your application.conf file (Section 'spray.can.server'):
```
  ssl-encryption = on
  # absolute path to keystore file
  keystore = "/some/path/sjs.jks"
  keystorePW = "changeit"
```

You will need a keystore that contains the server certificate. The bare minimum is achieved with this command which creates a self-signed certificate:
```
 keytool -genkey -keyalg RSA -alias jobserver -keystore ~/sjs.jks -storepass changeit -validity 360 -keysize 2048
```
You may place the keystore anywhere.    
Here is an example of a simple curl command that utilizes ssl:
```
curl -k https://localhost:8090/contexts
```
The ```-k``` flag tells curl to "Allow connections to SSL sites without certs". Export your server certificate and import it into the client's truststore to fully utilize ssl security. 

### Authentication

Authentication uses the [Apache Shiro](http://shiro.apache.org/index.html) framework. Authentication is activated by setting this flag (Section 'shiro'): 
```
authentication = on
# absolute path to shiro config file, including file name
config.path = "/some/path/shiro.ini"
```
Shiro-specific configuration options should be placed into a file named 'shiro.ini' in the directory as specified by the config option 'config.path'. 
Here is an example that configures LDAP with user group verification:
```
# use this for basic ldap authorization, without group checking
# activeDirectoryRealm = org.apache.shiro.realm.ldap.JndiLdapRealm
# use this for checking group membership of users based on the 'member' attribute of the groups:
activeDirectoryRealm = spark.jobserver.auth.LdapGroupRealm
# search base for ldap groups (only relevant for LdapGroupRealm):
activeDirectoryRealm.contextFactory.environment[ldap.searchBase] = dc=xxx,dc=org
# allowed groups (only relevant for LdapGroupRealm):
activeDirectoryRealm.contextFactory.environment[ldap.allowedGroups] = "cn=group1,ou=groups", "cn=group2,ou=groups"
activeDirectoryRealm.contextFactory.environment[java.naming.security.credentials] = password
activeDirectoryRealm.contextFactory.url = ldap://localhost:389
activeDirectoryRealm.userDnTemplate = cn={0},ou=people,dc=xxx,dc=org

cacheManager = org.apache.shiro.cache.MemoryConstrainedCacheManager

securityManager.cacheManager = $cacheManager
```

Make sure to edit the url, credentials, userDnTemplate, ldap.allowedGroups and ldap.searchBase settings in accordance with your local setup.

Here is an example of a simple curl command that authenticates a user and uses ssl (you may want to use -H to hide the 
credentials, this is just a simple example to get you started):
```
curl -k --basic --user 'user:pw' https://localhost:8090/contexts
```

## Deployment

### Manual steps

1. Copy `config/local.sh.template` to `<environment>.sh` and edit as appropriate.  NOTE: be sure to set SPARK_VERSION if you need to compile against a different version, ie. 1.4.1 for job server 0.5.2
2. `bin/server_deploy.sh <environment>` -- this packages the job server along with config files and pushes
   it to the remotes you have configured in `<environment>.sh`
3. On the remote server, start it in the deployed directory with `server_start.sh` and stop it with `server_stop.sh`

The `server_start.sh` script uses `spark-submit` under the hood and may be passed any of the standard extra arguments from `spark-submit`.

NOTE: by default the assembly jar from `job-server-extras`, which includes support for SQLContext and HiveContext, is used.  If you face issues with all the extra dependencies, consider modifying the install scripts to invoke `sbt job-server/assembly` instead, which doesn't include the extra dependencies.

Note: to test out the deploy to a local staging dir, or package the job server for Mesos,
use `bin/server_package.sh <environment>`.

### Chef

There is also a [Chef cookbook](https://github.com/spark-jobserver/chef-spark-jobserver) which can be used to deploy Spark Jobserver.

## Architecture

The job server is intended to be run as one or more independent processes, separate from the Spark cluster
(though it very well may be collocated with say the Master).

At first glance, it seems many of these functions (eg job management) could be integrated into the Spark standalone master.  While this is true, we believe there are many significant reasons to keep it separate:

- We want the job server to work for Mesos and YARN as well
- Spark and Mesos masters are organized around "applications" or contexts, but the job server supports running many discrete "jobs" inside a single context
- We want it to support Shark functionality in the future
- Loose coupling allows for flexible HA arrangements (multiple job servers targeting same standalone master, or possibly multiple Spark clusters per job server)

Flow diagrams are checked in in the doc/ subdirectory.  .diagram files are for websequencediagrams.com... check them out, they really will help you understand the flow of messages between actors.

## API

### Jars

    GET /jars            - lists all the jars and the last upload timestamp
    POST /jars/<appName> - uploads a new jar under <appName>

### Contexts

    GET /contexts           - lists all current contexts
    POST /contexts/<name>   - creates a new context
    DELETE /contexts/<name> - stops a context and all jobs running in it

### Jobs

Jobs submitted to the job server must implement a `SparkJob` trait.  It has a main `runJob` method which is
passed a SparkContext and a typesafe Config object.  Results returned by the method are made available through
the REST API.

    GET /jobs                - Lists the last N jobs
    POST /jobs               - Starts a new job, use ?sync=true to wait for results
    GET /jobs/<jobId>        - Gets the result or status of a specific job
    DELETE /jobs/<jobId>     - Kills the specified job
    GET /jobs/<jobId>/config - Gets the job configuration

For details on the Typesafe config format used for input (JSON also works), see the [Typesafe Config docs](https://github.com/typesafehub/config).

### Context configuration

A number of context-specific settings can be controlled when creating a context (POST /contexts) or running an
ad-hoc job (which creates a context on the spot).  For example, add urls of dependent jars for a context.

    POST '/contexts/my-new-context?dependent-jar-uris=file:///some/path/of/my-foo-lib.jar'

When creating a context via POST /contexts, the query params are used to override the default configuration in
spark.context-settings.  For example,

    POST /contexts/my-new-context?num-cpu-cores=10

would override the default spark.context-settings.num-cpu-cores setting.

When starting a job, and the context= query param is not specified, then an ad-hoc context is created.  Any
settings specified in spark.context-settings will override the defaults in the job server config when it is
started up.

Any spark configuration param can be overridden either in POST /contexts query params, or through `spark
.context-settings` job configuration.  In addition, `num-cpu-cores` maps to `spark.cores.max`, and `mem-per-
node` maps to `spark.executor.memory`.  Therefore the following are all equivalent:

    POST /contexts/my-new-context?num-cpu-cores=10

    POST /contexts/my-new-context?spark.cores.max=10

or in the job config when using POST /jobs,

    spark.context-settings {
        spark.cores.max = 10
    }

To pass settings directly to the sparkConf that do not use the "spark." prefix "as-is", use the "passthrough" section.

    spark.context-settings {
        spark.cores.max = 10
        passthrough {
          some.custom.hadoop.config = "192.168.1.1"
        }
    }

For the exact context configuration parameters, see JobManagerActor docs as well as application.conf.

Also see the [yarn doc](doc/yarn.md) for more tips.

### Job Result Serialization

The result returned by the `SparkJob` `runJob` method is serialized by the job server into JSON for routes
that return the result (GET /jobs with sync=true, GET /jobs/<jobId>).  Currently the following types can be
serialized properly:

- String, Int, Long, Double, Float, Boolean
- Scala Map's with string key values (non-string keys may be converted to strings)
- Scala Seq's
- Array's
- Anything that implements Product (Option, case classes) -- they will be serialized as lists
- Maps and Seqs may contain nested values of any of the above

If we encounter a data type that is not supported, then the entire result will be serialized to a string.

## Contribution and Development
Contributions via Github Pull Request are welcome.  See the TODO for some ideas.

- If you need to build with a specific scala version use ++x.xx.x followed by the regular command,
for instance: `sbt ++2.11.6 job-server/compile` 
- From the "master" project, please run "test" to ensure nothing is broken.
   - You may need to set `SPARK_LOCAL_IP` to `localhost` to ensure Akka port can bind successfully
- Logging for tests goes to "job-server-test.log"
- Run `scoverage:test` to check the code coverage and improve it
- Please run scalastyle to ensure your code changes don't break the style guide
- Do "reStart" from SBT for quick restarts of the job server process
- Please update the g8 template if you change the SparkJob API

### Publishing packages

In the root project, do `release cross`.

To announce the release on [ls.implicit.ly](http://ls.implicit.ly/), use
[Herald](https://github.com/n8han/herald#install) after adding release notes in
the `notes/` dir.  Also regenerate the catalog with `lsWriteVersion` SBT task
and `lsync`, in project job-server.

## Contact

For user/dev questions, we are using google group for discussions:
<https://groups.google.com/forum/#!forum/spark-jobserver>

Please report bugs/problems to:
<https://github.com/spark-jobserver/spark-jobserver/issues>

## License
Apache 2.0, see LICENSE.md

## TODO

- More debugging for classpath issues
- Update .g8 template, consider creating Activator template for sample job	
- Add Swagger support.  See the spray-swagger project.
- Implement an interactive SQL window.  See: [spark-admin](https://github.com/adatao/spark-admin)

- Stream the current job progress via a Listener
- Add routes to return stage info for a job.  Persist it via DAO so that we can always retrieve stage / performance info
  even for historical jobs.  This would be pretty kickass.
