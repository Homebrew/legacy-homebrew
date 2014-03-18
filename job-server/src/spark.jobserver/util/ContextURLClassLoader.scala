package spark.jobserver.util

import java.net.{URLClassLoader, URL}
import org.slf4j.LoggerFactory

/**
 * The addURL method in URLClassLoader is protected. We subclass it to make this accessible.
 * NOTE: This is copied from Spark's ExecutorURLClassLoader, which is private[spark].
 */
class ContextURLClassLoader(urls: Array[URL], parent: ClassLoader)
  extends URLClassLoader(urls, parent) {

  val logger = LoggerFactory.getLogger(getClass)

  override def addURL(url: URL) {
    if (!getURLs.contains(url)) {
      super.addURL(url)
      logger.info("Added URL " + url + " to ContextURLClassLoader")
    }
  }
}
