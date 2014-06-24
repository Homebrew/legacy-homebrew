package spark.jobserver.util

import com.typesafe.config.Config
import org.apache.spark.SparkConf
import scala.util.Try

/**
 * Holds a few functions common to Job Server SparkJob's and SparkContext's
 */
object SparkJobUtils {
  import collection.JavaConverters._

  /**
   * Creates a SparkConf for initializing a SparkContext based on various configs.
   * Note that anything in contextConfig with keys beginning with spark. get
   * put directly in the SparkConf.
   *
   * @param config the overall Job Server configuration (Typesafe Config)
   * @param contextConfig the Typesafe Config specific to initializing this context
   *                      (typically based on particular context/job)
   * @param contextName the context name
   * @return a SparkConf with everything properly configured
   */
  def configToSparkConf(config: Config, contextConfig: Config,
                        contextName: String): SparkConf = {
    val conf = new SparkConf()
    conf.setMaster(config.getString("spark.master"))
        .setAppName(contextName)

    for (cores <- Try(contextConfig.getInt("num-cpu-cores"))) {
      conf.set("spark.cores.max", cores.toString)
    }
    // Should be a -Xmx style string eg "512m", "1G"
    for (nodeMemStr <- Try(contextConfig.getString("memory-per-node"))) {
      conf.set("spark.executor.memory", nodeMemStr)
    }

    Try(config.getString("spark.home")).foreach { home => conf.setSparkHome(home) }

    // Set the Jetty port to 0 to find a random port
    conf.set("spark.ui.port", "0")

    // Set number of akka threads
    // TODO: need to figure out how many extra threads spark needs, besides the job threads
    conf.set("spark.akka.threads", (getMaxRunningJobs(config) + 4).toString)

    // Set any other settings in context config that start with "spark"
    for (e <- contextConfig.entrySet().asScala if e.getKey.startsWith("spark.")) {
      conf.set(e.getKey, e.getValue.unwrapped.toString)
    }

    conf
  }

  /**
   * Returns the maximum number of jobs that can run at the same time
   */
  def getMaxRunningJobs(config: Config): Int = {
    val cpuCores = Runtime.getRuntime.availableProcessors
    Try(config.getInt("spark.jobserver.max-jobs-per-context")).getOrElse(cpuCores)
  }
}
