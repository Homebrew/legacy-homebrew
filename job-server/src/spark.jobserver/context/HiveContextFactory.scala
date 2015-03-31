package spark.jobserver.context

import com.typesafe.config.Config
import org.apache.spark.{SparkConf, SparkContext}
import org.apache.spark.sql.hive.HiveContext
import spark.jobserver.{ContextLike, SparkHiveJob, SparkJobBase}
import spark.jobserver.util.SparkJobUtils

class HiveContextFactory extends SparkContextFactory {
  import SparkJobUtils._

  type C = HiveContext with ContextLike

  def makeContext(config: Config, contextConfig: Config, contextName: String): C = {
    val conf = configToSparkConf(config, contextConfig, contextName)
    contextFactory(conf)
  }

  protected def contextFactory(conf: SparkConf): C = {
    new HiveContext(new SparkContext(conf)) with HiveContextLike
  }
}

protected[jobserver] trait HiveContextLike extends ContextLike {
  def isValidJob(job: SparkJobBase): Boolean = job.isInstanceOf[SparkHiveJob]
  def stop() { this.sparkContext.stop() }
}
