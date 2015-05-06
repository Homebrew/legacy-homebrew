package spark.jobserver

import com.typesafe.config.{Config, ConfigFactory}
import org.apache.spark._
import org.apache.spark.sql.hive.HiveContext

/**
 * A test job that accepts a HiveContext, as opposed to the regular SparkContext.
 * Initializes some dummy data into a table, reads it back out, and returns a count
 * (Will create Hive metastore at job-server/metastore_db if Hive isn't configured)
 */
object HiveLoaderJob extends SparkHiveJob {
  // The following data is stored at ./test_addresses.txt
  // val addresses = Seq(
  //   Address("Bob", "Charles", "101 A St.", "San Jose"),
  //   Address("Sandy", "Charles", "10200 Ranch Rd.", "Purple City"),
  //   Address("Randy", "Charles", "101 A St.", "San Jose")
  // )

  val tableCreate = "CREATE TABLE `default.test_addresses`"
  val tableArgs = "(`firstName` String,`lastName` String, `address` String, `city` String)"
  val tableRowFormat = "ROW FORMAT DELIMITED FIELDS TERMINATED BY '\001'"
  val tableColFormat = "COLLECTION ITEMS TERMINATED BY '\002'"
  val tableMapFormat = "MAP KEYS TERMINATED BY '\003' STORED"
  val tableAs = "AS TextFile"

  //Will fail with a 'SemanticException : Invalid path' if this file is not there
  val loadPath:String = "'test/spark.jobserver/hive_test_job_addresses.txt'"

  def validate(hive: HiveContext, config: Config): SparkJobValidation = SparkJobValid

  def runJob(hive: HiveContext, config: Config): Any = {
    hive.sql("DROP TABLE if exists `default.test_addresses`")
    hive.sql(s"$tableCreate $tableArgs $tableRowFormat $tableColFormat $tableMapFormat $tableAs")
    hive.sql(s"LOAD DATA LOCAL INPATH $loadPath OVERWRITE INTO TABLE `default.test_addresses`")

    val addrRdd = hive.sql("SELECT * FROM `default.test_addresses`")
    addrRdd.count()
  }
}

/**
 * This job simply runs the Hive SQL in the config.
 */
object HiveTestJob extends SparkHiveJob {
  def validate(hive: HiveContext, config: Config): SparkJobValidation = SparkJobValid

  def runJob(hive: HiveContext, config: Config): Any = {
    hive.sql(config.getString("sql")).collect()
  }
}
