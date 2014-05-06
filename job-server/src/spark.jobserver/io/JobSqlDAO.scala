package spark.jobserver.io

import com.typesafe.config.Config
import java.sql.Timestamp
import org.slf4j.LoggerFactory
import scala.slick.driver.H2Driver.simple._
import java.io.File


class JobSqlDAO(config: Config) extends JobDAO {
  private val logger = LoggerFactory.getLogger(getClass)

  private val rootDir = getOrElse(config.getString("spark.jobserver.sqldao.rootdir"),
    "/tmp/spark-jobserver/sqldao/data")
  private val rootDirFile = new File(rootDir)
  logger.info("rootDir is " + rootDirFile.getAbsolutePath)

  // Definition of the tables
  class Jars(tag: Tag) extends Table[(String, Timestamp, Array[Byte])](tag, "JARS") {
    def appName = column[String]("APP_NAME")
    def uploadTime = column[Timestamp]("UPLOAD_TIME")
    def jar = column[Array[Byte]]("JAR")
    // Every table needs a * projection with the same type as the table's type parameter
    def * = (appName, uploadTime, jar)
  }
  val jars = TableQuery[Jars]

  // DB initialization
  val jdbcUrl = "jdbc:h2:file:" + rootDir + "/h2-db"
  val db = Database.forURL(jdbcUrl, driver = "org.h2.Driver")

  // Server initialization
  init()

  private def init() {
    // Create the data directory if it doesn't exist
    if (!rootDirFile.exists()) {
      if (!rootDirFile.mkdirs()) {
        throw new RuntimeException("Could not create directory " + rootDir)
      }
    }

    // Create the tables if they don't exist
    db withSession {
      implicit session =>

        if (MTable.getTables("JARS").list().isEmpty) {
          logger.info("Table JARS doesn't exist. Create all tables.")
          jars.ddl.create
          // TODO: Later, other tables should be created here too.
        }
    }
  }

}
