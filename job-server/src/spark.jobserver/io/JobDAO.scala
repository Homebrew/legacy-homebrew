package spark.jobserver.io

import com.typesafe.config._
import org.joda.time.{ Duration, DateTime }

// Uniquely identifies the jar used to run a job
case class JarInfo(appName: String, uploadTime: DateTime)

// Both a response and used to track job progress
// NOTE: if endTime is not None, then the job has finished.
case class JobInfo(jobId: String, contextName: String,
                   jarInfo: JarInfo, classPath: String,
                   startTime: DateTime, endTime: Option[DateTime],
                   error: Option[Throwable]) {
  def jobLengthMillis: Option[Long] = endTime.map { end => new Duration(startTime, end).getMillis() }

  def isRunning: Boolean = !endTime.isDefined
  def isErroredOut: Boolean = endTime.isDefined && error.isDefined
}

/**
 * Core trait for data access objects for persisting data such as jars, applications, jobs, etc.
 */
trait JobDAO {
  /**
   * Persist a jar.
   *
   * @param appName
   * @param uploadTime
   * @param jarBytes
   */
  def saveJar(appName: String, uploadTime: DateTime, jarBytes: Array[Byte])

  /**
   * Return all applications name and their last upload times.
   *
   * @return
   */
  def getApps: Map[String, DateTime]

  /**
   * TODO(kelvinchu): Remove this method later when JarManager doesn't use it anymore.
   *
   * @param appName
   * @param uploadTime
   * @return the local file path of the retrieved jar file.
   */
  def retrieveJarFile(appName: String, uploadTime: DateTime): String

  /**
   * Persist a job info.
   *
   * @param jobInfo
   */
  def saveJobInfo(jobInfo: JobInfo)

  /**
   * Return job info for a specific job id.
   *
   * @return
   */
  def getJobInfo(jobId: String): Option[JobInfo]

  /**
   * Return all job ids to their job info.
   *
   * @return
   */
  def getJobInfos(limit: Int): Seq[JobInfo]

  /**
   * Persist a job configuration along with provided jobId.
   *
   * @param jobId
   * @param jobConfig
   */
  def saveJobConfig(jobId: String, jobConfig: Config)

  /**
   * Return all job ids to their job configuration.
   *
   * @return
   */
  def getJobConfigs: Map[String, Config]

  /**
   * Returns the last upload time for a given app name.
   * @return Some(lastUploadedTime) if the app exists and the list of times is nonempty, None otherwise
   */
  def getLastUploadTime(appName: String): Option[DateTime] =
    getApps.get(appName)
}
