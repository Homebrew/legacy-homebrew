package spark.jobserver.context

import com.typesafe.config.Config
import org.apache.spark.{SparkConf, SparkContext}
import org.apache.spark.sql.SQLContext
import spark.jobserver.{ContextLike, SparkSqlJob, SparkJobBase}
import spark.jobserver.util.SparkJobUtils

class SQLContextFactory extends SparkContextFactory {
  type C = SQLContext with ContextLike

  def makeContext(sparkConf: SparkConf, config: Config,  contextName: String): C = {
    new SQLContext(new SparkContext(sparkConf)) with ContextLike {
      def isValidJob(job: SparkJobBase): Boolean = job.isInstanceOf[SparkSqlJob]
      def stop() { this.sparkContext.stop() }
    }
  }
}