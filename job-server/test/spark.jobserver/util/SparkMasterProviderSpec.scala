package spark.jobserver.util

import com.typesafe.config.{Config, ConfigFactory}
import org.apache.spark.SparkConf
import org.scalatest.{Matchers, FunSpec}

class SparkMasterProviderSpec extends FunSpec with Matchers {

  import collection.JavaConverters._


  val contextName = "demo"

  def getSparkConf(baseConfig: Config): SparkConf =
    SparkJobUtils.configToSparkConf(baseConfig, ConfigFactory.empty(), contextName)

  describe("SparkMasterProvider.fromConfig") {
    it("should be able to dynamically use a class to find the spark.master") {

      val config = ConfigFactory.parseMap(Map(
        "spark.home" -> "/etc/spark",
        SparkMasterProvider.SparkMasterProperty -> "spark.jobserver.util.TestProvider"
      ).asJava)

      val sparkConf = getSparkConf(config)
      sparkConf.get("spark.master") should equal("TestMaster")
    }

    it("should be able to use a DefaultSparkMaster Provider if no spark.maser.provider is found") {

      val config = ConfigFactory.parseMap(Map(
        "spark.home" -> "/etc/spark",
        "spark.master" -> "NotTestMaster"
      ).asJava)

      val sparkConf = getSparkConf(config)
      sparkConf.get("spark.master") should equal("NotTestMaster")
    }

    it(s"should throw an exception if an invalid class is set as ${SparkMasterProvider.SparkMasterProperty}") {
      intercept[Exception] {
        val config = ConfigFactory.parseMap(Map(
          "spark.home" -> "/etc/spark",
          "spark.master.provider" -> "not.exists.provider"
        ).asJava)
        val sparkConf = getSparkConf(config)
      }
    }
  }
}

object TestProvider extends SparkMasterProvider {
  /**
   * This test class always returns "TestMaster" as the master address
   */
  override def getSparkMaster(config: Config): String = "TestMaster"
}