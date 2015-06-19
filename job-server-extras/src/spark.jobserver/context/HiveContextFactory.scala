package spark.jobserver.context

import com.typesafe.config.Config
import org.apache.spark.{SparkConf, SparkContext}
import org.apache.spark.sql.hive.HiveContext
import spark.jobserver.{ContextLike, SparkHiveJob, SparkJobBase}
import spark.jobserver.util.SparkJobUtils

class HiveContextFactory extends SparkContextFactory {
  type C = HiveContext with ContextLike

  def makeContext(sparkConf: SparkConf, config: Config,  contextName: String): C = {
    contextFactory(sparkConf)
  }

  protected def contextFactory(conf: SparkConf): C = {
    new HiveContext(new SparkContext(conf)) with HiveContextLike
  }
}

private[jobserver] trait HiveContextLike extends ContextLike {
  def isValidJob(job: SparkJobBase): Boolean = job.isInstanceOf[SparkHiveJob]
  def stop() { this.sparkContext.stop() }
}
