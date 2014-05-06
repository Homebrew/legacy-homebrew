package spark.jobserver.io

import com.typesafe.config.Config
import java.io.{FileOutputStream, BufferedOutputStream, File}
import java.sql.Timestamp
import org.joda.time.DateTime
import org.slf4j.LoggerFactory
import scala.slick.driver.H2Driver.simple._
import scala.slick.jdbc.meta.MTable


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

  override def saveJar(appName: String, uploadTime: DateTime, jarBytes: Array[Byte]) {
    // The order is important. Save the jar file first and then log it into database.
    cacheJar(appName, uploadTime, jarBytes)

    // log it into database
    insertJarInfo(JarInfo(appName, uploadTime), jarBytes)
  }

  override def getApps: Map[String, DateTime] = {
    db withSession {
      implicit session =>

      // It's "select appName, max(uploadTime) from jars group by appName
      // max(uploadTime) is the latest upload time of the jar.
        val query = jars.groupBy { _.appName }.map {
          case (appName, jar) => (appName -> jar.map(_.uploadTime).max.get)
        }

        query.list.map {
          case (appName: String, timestamp: Timestamp) => (appName, convertDateSqlToJoda(timestamp))
        }.toMap
    }
  }

  // Insert JarInfo and its jar into db
  private def insertJarInfo(jarInfo: JarInfo, jarBytes: Array[Byte]) {
    // Insert JarInfo and its jar
    db withSession {
      implicit session =>

        jars += (jarInfo.appName, convertDateJodaToSql(jarInfo.uploadTime), jarBytes)
    }
  }

  // Fetch the jar from the database
  private def fetchJar(appName: String, uploadTime: DateTime): Array[Byte] = {
    db withSession {
      implicit session =>

        val dateTime = convertDateJodaToSql(uploadTime)
        val query = jars.filter { jar =>
          jar.appName === appName && jar.uploadTime === dateTime
        }.map( _.jar )

        // TODO: check if this list is empty?
        query.list.head
    }
  }

  // Cache the jar file into local file system.
  private def cacheJar(appName: String, uploadTime: DateTime, jarBytes: Array[Byte]) {
    val outFile = new File(rootDir, createJarName(appName, uploadTime) + ".jar")
    val bos = new BufferedOutputStream(new FileOutputStream(outFile))
    try {
      logger.debug("Writing {} bytes to file {}", jarBytes.size, outFile.getPath)
      bos.write(jarBytes)
      bos.flush()
    } finally {
      bos.close()
    }
  }

  private def createJarName(appName: String, uploadTime: DateTime): String = appName + "-" + uploadTime

  // Convert from joda DateTime to java.sql.Timestamp
  private def convertDateJodaToSql(dateTime: DateTime): Timestamp =
    new Timestamp(dateTime.getMillis())

  // Convert from java.sql.Timestamp to joda DateTime
  private def convertDateSqlToJoda(timestamp: Timestamp): DateTime =
    new DateTime(timestamp.getTime())

}
