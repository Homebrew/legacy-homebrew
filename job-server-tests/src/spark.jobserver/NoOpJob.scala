package spark.jobserver

import com.typesafe.config.{Config, ConfigFactory}
import org.apache.spark._

/**
 * An empty no computation job for stress tests purpose.
 */
object NoOpJob extends SparkJob {
  def main(args: Array[String]) {
    val sc = new SparkContext("local[4]", "NoOpJob")
    val config = ConfigFactory.parseString("")
    val results = runJob(sc, config)
    println("Result is " + results)
  }

  def validate(sc: SparkContext, config: Config): SparkJobValidation = SparkJobValid

  def runJob(sc: SparkContext, config: Config): Any = 1
}
