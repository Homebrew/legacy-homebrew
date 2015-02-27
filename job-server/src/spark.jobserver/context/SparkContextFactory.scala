package spark.jobserver.context

import com.typesafe.config.Config
import org.apache.spark.SparkContext
import spark.jobserver.{ContextLike, SparkJob, SparkJobBase}
import spark.jobserver.util.SparkJobUtils

/**
 * Factory trait for creating a SparkContext or any derived Contexts,
 * such as SQLContext, StreamingContext, HiveContext, etc.
 * My implementing classes can be dynamically loaded using classloaders to ensure that the entire
 * SparkContext has access to certain dynamically loaded classes, for example, job jars.
 */
trait SparkContextFactory {
  type C <: ContextLike

  /**
   * Creates a SparkContext or derived context.
   * @param config the overall system / job server Typesafe Config
   * @param contextConfig the config specific to this particular job
   * @param contextName the name of the context to start
   * @return the newly created context.
   */
  def makeContext(config: Config, contextConfig: Config, contextName: String): C
}

/**
 * The default factory creates a standard SparkContext.
 * In the future if we want to add additional methods, etc. then we can have additional factories.
 * For example a specialized SparkContext to manage RDDs in a user-defined way.
 *
 * If you create your own SparkContextFactory, please make sure it has zero constructor args.
 */
class DefaultSparkContextFactory extends SparkContextFactory {
  import SparkJobUtils._

  type C = SparkContext with ContextLike

  def makeContext(config: Config, contextConfig: Config, contextName: String): C = {
    val conf = configToSparkConf(config, contextConfig, contextName)
    new SparkContext(conf) with ContextLike {
      def sparkContext: SparkContext = this
      def isValidJob(job: SparkJobBase): Boolean = job.isInstanceOf[SparkJob]
    }
  }
}
