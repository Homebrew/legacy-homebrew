package spark.jobserver.io

import com.typesafe.config.{ConfigRenderOptions, Config, ConfigFactory}
import java.io.{FileOutputStream, BufferedOutputStream, File}
import java.sql.Timestamp
import org.joda.time.DateTime
import org.slf4j.LoggerFactory
import scala.slick.jdbc.meta.MTable


class JobSqlDAO(config: Config) extends JobDAO {
  import scala.slick.driver.H2Driver.simple._

  private val logger = LoggerFactory.getLogger(getClass)

  private val rootDir = getOrElse(config.getString("spark.jobserver.sqldao.rootdir"),
    "/tmp/spark-jobserver/sqldao/data")
  private val rootDirFile = new File(rootDir)
  logger.info("rootDir is " + rootDirFile.getAbsolutePath)

  // Definition of the tables
  //scalastyle:off
  class Jars(tag: Tag) extends Table[(Int, String, Timestamp, Array[Byte])](tag, "JARS") {
    def jarId = column[Int]("JAR_ID", O.PrimaryKey, O.AutoInc)
    def appName = column[String]("APP_NAME")
    def uploadTime = column[Timestamp]("UPLOAD_TIME")
    def jar = column[Array[Byte]]("JAR")
    // Every table needs a * projection with the same type as the table's type parameter
    def * = (jarId, appName, uploadTime, jar)
  }
  val jars = TableQuery[Jars]

  // Explicitly avoiding to label 'jarId' as a foreign key to avoid dealing with
  // referential integrity constraint violations.
  class Jobs(tag: Tag) extends Table[(String, String, Int, String, Timestamp,
                                      Option[Timestamp], Option[String])] (tag, "JOBS") {
    def jobId = column[String]("JOB_ID", O.PrimaryKey)
    def contextName = column[String]("CONTEXT_NAME")
    def jarId = column[Int]("JAR_ID") // FK to JARS table
    def classPath = column[String]("CLASSPATH")
    def startTime = column[Timestamp]("START_TIME")
    def endTime = column[Option[Timestamp]]("END_TIME")
    def error = column[Option[String]]("ERROR")
    def * = (jobId, contextName, jarId, classPath, startTime, endTime, error)
  }
  val jobs = TableQuery[Jobs]

  class Configs(tag: Tag) extends Table[(String, String)](tag, "CONFIGS") {
    def jobId = column[String]("JOB_ID", O.PrimaryKey)
    def jobConfig = column[String]("JOB_CONFIG")
    def * = (jobId, jobConfig)
  }
  //scalastyle:on
  val configs = TableQuery[Configs]

  // DB initialization
  val defaultJdbcUrl = "jdbc:h2:file:" + rootDir + "/h2-db"
  val jdbcUrl = getOrElse(config.getString("spark.jobserver.sqldao.jdbc.url"), defaultJdbcUrl)
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

        if (isAllTablesNotExist()) {
          // All tables don't exist. It's the first time the Job Server runs. So, create all tables.
          logger.info("Creating JARS, CONFIGS and JOBS tables ...")
          jars.ddl.create
          configs.ddl.create
          jobs.ddl.create
        } else if (isSomeTablesNotExist()) {
          // Only some tables exist, not all. It means there is data corruption in the metadata-store.
          // Exit the Job Server now.
          throw new RuntimeException("Some tables in metadata-store are missing. Please recover it first.")
        }

        // If the cases above are not true, it means all tables exit. No need to initialize the database.
    }
  }

  // Check if a single exist
  private def isTableExist(tableName: String)(implicit session: Session): Boolean =
    !MTable.getTables(tableName).list().isEmpty

  // Check if "all tables don't exist" is true
  private def isAllTablesNotExist()(implicit session: Session): Boolean =
    !isTableExist("JARS") && !isTableExist("CONFIGS") && !isTableExist("JOBS")

  // Check if "some tables don't exist" is true
  private def isSomeTablesNotExist()(implicit session: Session): Boolean =
    !isTableExist("JARS") || !isTableExist("CONFIGS") || !isTableExist("JOBS")

  override def saveJar(appName: String, uploadTime: DateTime, jarBytes: Array[Byte]) {
    // The order is important. Save the jar file first and then log it into database.
    cacheJar(appName, uploadTime, jarBytes)

    // log it into database
    val jarId = insertJarInfo(JarInfo(appName, uploadTime), jarBytes)
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
          case (appName: String, timestamp: Timestamp) =>
            (appName, convertDateSqlToJoda(timestamp))
        }.toMap
    }
  }

  // Insert JarInfo and its jar into db and return the primary key associated with that row
  private def insertJarInfo(jarInfo: JarInfo, jarBytes: Array[Byte]): Int = {
    // Must provide a value that will be ignored because the JARS jobId column
    // is tagged with O.AutoInc
    val IGNORED_VAL = -1

    db withSession {
      implicit session =>

        (jars returning jars.map(_.jarId)) +=
          (IGNORED_VAL, jarInfo.appName, convertDateJodaToSql(jarInfo.uploadTime), jarBytes)
    }
  }

  override def retrieveJarFile(appName: String, uploadTime: DateTime): String = {
    val jarFile = new File(rootDir, createJarName(appName, uploadTime) + ".jar")
    if (!jarFile.exists()) {
      fetchAndCacheJarFile(appName, uploadTime)
    }
    jarFile.getAbsolutePath
  }

  // Fetch the jar file from database and cache it into local file system.
  private def fetchAndCacheJarFile(appName: String, uploadTime: DateTime) {
    val jarBytes = fetchJar(appName, uploadTime)
    cacheJar(appName, uploadTime, jarBytes)
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

  // Fetch the primary key for a particular jar from the database
  // TODO: Might not be needed but was very quick to implement
  private def fetchJarId(appName: String, uploadTime: DateTime): Int = {
    db withSession {
      implicit session =>

        queryJarId(appName, uploadTime)
    }
  }

  private def queryJarId(appName: String, uploadTime: DateTime)(implicit session: Session): Int = {
    val dateTime = convertDateJodaToSql(uploadTime)
    val query = jars.filter { jar =>
      jar.appName === appName && jar.uploadTime === dateTime
    }.map( _.jarId )

    query.list.head
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

  override def getJobConfigs: Map[String, Config] = {
    db withSession {
      implicit sessions =>

        configs.list.map { case (jobId, jobConfig) =>
          (jobId -> ConfigFactory.parseString(jobConfig))
        }.toMap
    }
  }

  override def saveJobConfig(jobId: String, jobConfig: Config) {
    db withSession {
      implicit sessions =>

        configs += (jobId, jobConfig.root().render(ConfigRenderOptions.concise()))
    }
  }

  override def saveJobInfo(jobInfo: JobInfo) {
    db withSession {
      implicit sessions =>

        // First, query JARS table for a jarId
        val jarId = queryJarId(jobInfo.jarInfo.appName, jobInfo.jarInfo.uploadTime)

        // Extract out the the JobInfo members and convert any members to appropriate SQL types
        val JobInfo(jobId, contextName, _, classPath, startTime, endTime, error) = jobInfo
        val (start, endOpt, errOpt) = (convertDateJodaToSql(startTime),
          endTime.map(convertDateJodaToSql(_)),
          error.map(_.getMessage))

        // When you run a job asynchronously, the same data is written twice with a different
        // endTime and error value. When the row does not exists we write the data as new, otherwise,
        // we want to update the row.
        val updateQuery = jobs.filter(_.jobId === jobId).map(job => (job.endTime, job.error))

        updateQuery.list.size match {
          case 0 => jobs += (jobId, contextName, jarId, classPath, start, endOpt, errOpt)
          case _ => updateQuery.update(endOpt, errOpt)
        }
    }
  }

  override def getJobInfos: Map[String, JobInfo] = {
    db withSession {
      implicit sessions =>

        // Join the JARS and JOBS tables without unnecessary columns
        val joinQuery = for {
          jar <- jars
          j <- jobs if j.jarId === jar.jarId
        } yield
          (j.jobId, j.contextName, jar.appName, jar.uploadTime, j.classPath, j.startTime, j.endTime, j.error)

        // Transform the each row of the table into a map of JobInfo values
        joinQuery.list.map { case (id, context, app, upload, classpath, start, end, err) =>
          id -> JobInfo(id,
            context,
            JarInfo(app, convertDateSqlToJoda(upload)),
            classpath,
            convertDateSqlToJoda(start),
            end.map(convertDateSqlToJoda(_)),
            err.map(new Throwable(_)))
        }.toMap
    }
  }
}
