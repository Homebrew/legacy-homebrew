package spark.jobserver.context

import java.util.concurrent.TimeUnit

import com.typesafe.config.Config
import org.apache.spark.SparkContext
import org.apache.spark.sql.SQLContext
import org.apache.spark.streaming.{Seconds, StreamingContext}
import spark.jobserver.{SparkStramingJob, SparkSqlJob, SparkJobBase, ContextLike}
import spark.jobserver.util.SparkJobUtils
import spark.jobserver.util.SparkJobUtils._

/**
 * Created by ZeoS on 3/18/15.
 */
class StreamingContextFactory extends SparkContextFactory{
  import SparkJobUtils._

  type C = StreamingContext with ContextLike

  def makeContext(config: Config, contextConfig: Config, contextName: String): C = {
    val conf = configToSparkConf(config, contextConfig, contextName)
    val interval :Int = {
      if (contextConfig.hasPath("streaming.batch_interval")) {
        contextConfig.getInt("streaming.batch_interval")
      } else {
        if (config.hasPath("streaming.batch_interval")) {
          config.getInt("streaming.batch_interval")
        } else {
          10
        }
      }
    }
    new StreamingContext(conf, Seconds(interval)) with ContextLike {
      def isValidJob(job: SparkJobBase): Boolean = job.isInstanceOf[SparkStramingJob]
      def stop() { this.sparkContext.stop() }
    }
  }
}
