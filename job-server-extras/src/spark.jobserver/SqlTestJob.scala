package spark.jobserver

import com.typesafe.config.Config
import org.apache.spark.sql.SQLContext

/**
 * A test job that accepts a SQLContext, as opposed to the regular SparkContext.
 * Just initializes some dummy data into a table.
 */
object SqlLoaderJob extends SparkSqlJob {
  case class Address(firstName: String, lastName: String, street: String, city: String)

  val addresses = Seq(
    Address("Bob", "Charles", "101 A St.", "San Jose"),
    Address("Sandy", "Charles", "10200 Ranch Rd.", "Purple City"),
    Address("Randy", "Charles", "101 A St.", "San Jose")
  )

  def validate(sql: SQLContext, config: Config): SparkJobValidation = SparkJobValid

  def runJob(sql: SQLContext, config: Config): Any = {
    import sql.implicits._
    val addrRdd = sql.sparkContext.parallelize(addresses)
    addrRdd.toDF().registerTempTable("addresses")
    addrRdd.count()
  }
}

/**
 * This job simply runs the SQL in the config.
 */
object SqlTestJob extends SparkSqlJob {
  def validate(sql: SQLContext, config: Config): SparkJobValidation = SparkJobValid

  def runJob(sql: SQLContext, config: Config): Any = {
    sql.sql(config.getString("sql")).collect()
  }
}
