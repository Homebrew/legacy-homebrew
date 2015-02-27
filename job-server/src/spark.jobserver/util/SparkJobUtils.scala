package spark.jobserver.util

import java.util.concurrent.TimeUnit

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

    // Set spark broadcast factory in yarn-client mode
    if (config.getString("spark.master") == "yarn-client") {
      conf.set("spark.broadcast.factory", config.getString("spark.jobserver.yarn-broadcast-factory"))
    }

    // Set number of akka threads
    // TODO: need to figure out how many extra threads spark needs, besides the job threads
    conf.set("spark.akka.threads", (getMaxRunningJobs(config) + 4).toString)

    // Set any other settings in context config that start with "spark"
    for (e <- contextConfig.entrySet().asScala if e.getKey.startsWith("spark.")) {
      conf.set(e.getKey, e.getValue.unwrapped.toString)
    }

    // Set any other settings in context config that start with "passthrough"
    // These settings will be directly set in sparkConf, but with "passthrough." stripped
    // This is useful for setting configurations for hadoop connectors such as
    // elasticsearch, cassandra, etc.
    for (e <- Try(contextConfig.getConfig("passthrough"))) {
         e.entrySet().asScala.map { s=>
            conf.set(s.getKey, s.getValue.unwrapped.toString)
         }
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

  /**
   * According "spark.master", returns the timeout of create sparkContext
   */
  def getContextTimeout(config: Config): Int = {
    config.getString("spark.master") match {
      case "yarn-client" =>
        Try(config.getDuration("spark.jobserver.yarn-context-creation-timeout",
              TimeUnit.MILLISECONDS).toInt / 1000).getOrElse(40)
      case _               =>
        Try(config.getDuration("spark.jobserver.context-creation-timeout",
              TimeUnit.MILLISECONDS).toInt / 1000).getOrElse(15)
    }
  }
}
