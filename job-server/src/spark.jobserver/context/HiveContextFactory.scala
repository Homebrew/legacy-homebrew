package spark.jobserver.context

import com.typesafe.config.Config
import org.apache.spark.SparkContext
import org.apache.spark.sql.hive.HiveContext
import spark.jobserver.{ContextLike, SparkHiveJob, SparkJobBase}
import spark.jobserver.util.SparkJobUtils

class HiveContextFactory extends SparkContextFactory {
  import SparkJobUtils._

  type C = HiveContext with ContextLike

  def makeContext(config: Config, contextConfig: Config, contextName: String): C = {
    val conf = configToSparkConf(config, contextConfig, contextName)
    new HiveContext(new SparkContext(conf)) with ContextLike {
      def isValidJob(job: SparkJobBase): Boolean = job.isInstanceOf[SparkHiveJob]
      def stop() { this.sparkContext.stop() }
    }
  }
}
