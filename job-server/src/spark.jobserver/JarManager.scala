package spark.jobserver

import ooyala.common.akka.InstrumentedActor
import spark.jobserver.io.JobDAO
import spark.jobserver.util.JarUtils
import org.joda.time.DateTime

// Messages to JarManager actor
case class StoreJar(appName: String, jarBytes: Array[Byte])
case object ListJars

// Responses
case object InvalidJar
case object JarStored

/**
 * An Actor that manages the jars stored by the job server.   It's important that threads do not try to
 * load a class from a jar as a new one is replacing it, so using an actor to serialize requests is perfect.
 */
class JarManager(jobDao: JobDAO) extends InstrumentedActor {
  override def wrappedReceive: Receive = {
    case ListJars => sender ! createJarsList()

    case StoreJar(appName, jarBytes) =>
      logger.info("Storing jar for app {}, {} bytes", appName, jarBytes.size)
      if (!JarUtils.validateJarBytes(jarBytes)) {
        sender ! InvalidJar
      } else {
        val uploadTime = DateTime.now()
        jobDao.saveJar(appName, uploadTime, jarBytes)
        sender ! JarStored
      }
  }

  private def createJarsList() = jobDao.getApps
}
