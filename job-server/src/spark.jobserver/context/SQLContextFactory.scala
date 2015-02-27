package spark.jobserver.context

import com.typesafe.config.Config
import org.apache.spark.SparkContext
import org.apache.spark.sql.SQLContext
import spark.jobserver.{ContextLike, SparkSqlJob, SparkJobBase}
import spark.jobserver.util.SparkJobUtils

class SQLContextFactory extends SparkContextFactory {
  import SparkJobUtils._

  type C = SQLContext with ContextLike

  def makeContext(config: Config, contextConfig: Config, contextName: String): C = {
    val conf = configToSparkConf(config, contextConfig, contextName)
    new SQLContext(new SparkContext(conf)) with ContextLike {
      def isValidJob(job: SparkJobBase): Boolean = job.isInstanceOf[SparkSqlJob]
      def stop() { this.sparkContext.stop() }
    }
  }
}