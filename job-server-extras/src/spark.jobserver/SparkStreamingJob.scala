package spark.jobserver

import org.apache.spark.streaming.StreamingContext

/**
 * Defines a Job that runs on a [[StreamingContext]], note that
 * these jobs are usually long running jobs and there's (yet) no way in Spark
 * Job Server to query the status of these jobs.
 */
trait SparkStreamingJob extends SparkJobBase {
  type C = StreamingContext
}
