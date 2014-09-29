package spark.jobserver

import java.net.URL
import org.apache.spark.{SparkContext, SparkEnv}
import org.joda.time.DateTime
import spark.jobserver.io.JobDAO
import spark.jobserver.util.{ContextURLClassLoader, LRUCache}

case class JobJarInfo(constructor: () => SparkJobBase,
                      className: String,
                      jarFilePath: String)

/**
 * A cache for SparkJob classes.  A lot of times jobs are run repeatedly, and especially for low-latency
 * jobs, why retrieve the jar and load it every single time?
 */
class JobCache(maxEntries: Int, dao: JobDAO, sparkContext: SparkContext, loader: ContextURLClassLoader) {
  private val cache = new LRUCache[(String, DateTime, String), JobJarInfo](maxEntries)

  /**
   * Retrieves the given SparkJob class from the cache if it's there, otherwise use the DAO to retrieve it.
   * @param appName the appName under which the jar was uploaded
   * @param uploadTime the upload time for the version of the jar wanted
   * @param classPath the fully qualified name of the class/object to load
   */
  def getSparkJob(appName: String, uploadTime: DateTime, classPath: String): JobJarInfo = {
    cache.get((appName, uploadTime, classPath), {
      val jarFilePath = new java.io.File(dao.retrieveJarFile(appName, uploadTime)).getAbsolutePath()
      sparkContext.addJar(jarFilePath)   // Adds jar for remote executors
      loader.addURL(new URL("file:" + jarFilePath))   // Now jar added for local loader
      val constructor = JarUtils.loadClassOrObject[SparkJobBase](classPath, loader)
      JobJarInfo(constructor, classPath, jarFilePath)
    })
  }
}
