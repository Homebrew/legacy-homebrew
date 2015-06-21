package spark.jobserver.context

import com.typesafe.config.Config
import org.apache.spark.SparkConf
import org.apache.spark.streaming.{Seconds, StreamingContext}
import spark.jobserver.{SparkStramingJob, ContextLike, SparkJobBase}

class StreamingContextFactory extends SparkContextFactory {

  type C = StreamingContext with ContextLike

  def makeContext(sparkConf: SparkConf, config: Config,  contextName: String): C = {
    val interval = config.getInt("streaming.batch_interval")
    new StreamingContext(sparkConf, Seconds(interval)) with ContextLike {
      def isValidJob(job: SparkJobBase): Boolean = job.isInstanceOf[SparkStramingJob]
      def stop() {
        //Gracefully stops the spark context
        stop(stopSparkContext = true, stopGracefully = false)
      }
    }
  }
}
