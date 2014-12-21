package spark.jobserver

import com.typesafe.config.{Config, ConfigFactory}
import org.apache.spark._
import org.apache.spark.sql.SQLContext

/**
 * A test job that accepts a SQLContext, as opposed to the regular SparkContext.
 */
object SqlTestJob extends SparkJobBase {
  type C = SQLContext

  def validate(sql: SQLContext, config: Config): SparkJobValidation = SparkJobValid

  def runJob(sql: SQLContext, config: Config): Any = 1
}
