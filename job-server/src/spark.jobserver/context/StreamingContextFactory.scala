package spark.jobserver.context

import java.util.concurrent.TimeUnit

import com.typesafe.config.Config
import org.apache.spark.{SparkConf, SparkContext}
import org.apache.spark.sql.SQLContext
import org.apache.spark.streaming.{Seconds, StreamingContext}
import spark.jobserver.{SparkStramingJob, SparkSqlJob, SparkJobBase, ContextLike}
import spark.jobserver.util.SparkJobUtils
import spark.jobserver.util.SparkJobUtils._

/**
 * Created by ZeoS on 3/18/15.
 */
class StreamingContextFactory extends SparkContextFactory{

  type C = StreamingContext with ContextLike

  def makeContext(sparkConf: SparkConf, config: Config,  contextName: String): C = {
    val interval = config.getInt("streaming.batch_interval")

    new StreamingContext(sparkConf, Seconds(interval)) with ContextLike {
      def isValidJob(job: SparkJobBase): Boolean = job.isInstanceOf[SparkStramingJob]
      def stop() {
        //Gracefully stops the spark context
        stop(true, true)
      }
    }
  }
}
