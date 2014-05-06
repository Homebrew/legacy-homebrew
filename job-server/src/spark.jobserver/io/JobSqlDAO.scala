package spark.jobserver.io

import com.typesafe.config.Config
import java.sql.Timestamp
import org.slf4j.LoggerFactory
import scala.slick.driver.H2Driver.simple._


class JobSqlDAO(config: Config) extends JobDAO {
  private val logger = LoggerFactory.getLogger(getClass)

  // Definition of the tables
  class Jars(tag: Tag) extends Table[(String, Timestamp, Array[Byte])](tag, "JARS") {
    def appName = column[String]("APP_NAME")
    def uploadTime = column[Timestamp]("UPLOAD_TIME")
    def jar = column[Array[Byte]]("JAR")
    // Every table needs a * projection with the same type as the table's type parameter
    def * = (appName, uploadTime, jar)
  }
  val jars = TableQuery[Jars]

}
