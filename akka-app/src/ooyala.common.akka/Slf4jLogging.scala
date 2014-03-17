package ooyala.common.akka

import akka.actor.Actor
import org.slf4j.LoggerFactory

/**
 * Trait that adds Logback/SLF4J logging to actors.  It adds the following members:
 *
 * * logger
 *
 * It also prints a message upon actor initialization.
 * Also, it fills the akkaSource MDC variable with the current actor's path, making for easier
 * log tracing of a single actor's messages.
 */
trait Slf4jLogging extends ActorStack {
  val logger = LoggerFactory.getLogger(getClass)
  private[this] val myPath = self.path.toString

  withAkkaSourceLogging {
    logger.info("Starting actor " + getClass.getName)
  }

  override def receive: Receive = {
    case x =>
      withAkkaSourceLogging {
        super.receive(x)
      }
  }

  private def withAkkaSourceLogging(fn: => Unit) {
    // Because each actor receive invocation could happen in a different thread, and MDC is thread-based,
    // we kind of have to set the MDC anew for each receive invocation.  :(
    try {
      org.slf4j.MDC.put("akkaSource", myPath)
      fn
    } finally {
      org.slf4j.MDC.remove("akkaSource")
    }
  }
}
