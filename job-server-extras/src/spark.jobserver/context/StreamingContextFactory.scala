package spark.jobserver.context

import com.typesafe.config.Config
import org.apache.spark.SparkConf
import org.apache.spark.streaming.{Milliseconds, StreamingContext}
import spark.jobserver.{ContextLike, SparkJobBase, SparkStreamingJob}

class StreamingContextFactory extends SparkContextFactory {

  type C = StreamingContext with ContextLike

  def makeContext(sparkConf: SparkConf, config: Config,  contextName: String): C = {
    val interval = config.getInt("streaming.batch_interval")
    val stopGracefully = config.getBoolean("streaming.stopGracefully")
    val stopSparkContext = config.getBoolean("streaming.stopSparkContext")
    new StreamingContext(sparkConf, Milliseconds(interval)) with ContextLike {
      def isValidJob(job: SparkJobBase): Boolean = job.isInstanceOf[SparkStreamingJob]
      def stop() {
        //Gracefully stops the spark context
        stop(stopSparkContext, stopGracefully)
      }
    }
  }
}
