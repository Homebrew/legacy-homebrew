package spark.jobserver.util

import scala.reflect.runtime.{universe => ru}
import com.typesafe.config.{ConfigException, Config}
import org.slf4j.LoggerFactory


trait SparkMasterProvider {

  /**
   * Implementing classes will determine what the appropriate SparkMaster is and
   * return it
   * @return A Spark Master Address
   */
  def getSparkMaster(config: Config): String

}

object SparkMasterProvider {
  val logger = LoggerFactory.getLogger(getClass)
  val SparkMasterProperty = "spark.master.provider"

  /**
   * Will look for an Object with the name provided in the Config file and return it
   * or the DefaultSparkMasterProvider if no spark.master.provider was specified
   * @param config SparkJobserver Config
   * @return A SparkMasterProvider
   */
  def fromConfig(config: Config): SparkMasterProvider = {

    try {
      val sparkMasterObjectName = config.getString(SparkMasterProperty)
      logger.info(s"Using $sparkMasterObjectName to determine Spark Master")
      val m = ru.runtimeMirror(getClass.getClassLoader)
      val module = m.staticModule(sparkMasterObjectName)
      val sparkMasterProviderObject = m.reflectModule(module).instance
        .asInstanceOf[SparkMasterProvider]
      sparkMasterProviderObject
    } catch {
      case me: ConfigException => DefaultSparkMasterProvider
      case e: Exception => throw e
    }
  }
}

/**
 * Default Spark Master Provider always returns "spark.master" from the passed in config
 */
object DefaultSparkMasterProvider extends SparkMasterProvider {

  def getSparkMaster(config: Config): String = config.getString("spark.master")

}
