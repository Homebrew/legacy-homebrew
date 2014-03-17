package ooyala.common.akka

import akka.actor.Actor

/**
 * Base class that includes Slf4jLogging and ActorMetrics for convenience
 */
abstract class InstrumentedActor extends Actor with Slf4jLogging with ActorMetrics {
  /** preRestart() is called when actor is killed due to exception, and will be restarted. It is
   *  run on the current actor instance that is about to be killed.   We just log errors.
   *  The super (original) method should call postStop() and shut down children as well.
   */
  override def preRestart(reason: Throwable, message: Option[Any]) {
    logger.error("About to restart actor due to exception:", reason)
    super.preRestart(reason, message)
  }

  /** postStop() is called when actor is stopped or restarted due to Exceptions **/
  override def postStop() { logger.warn("Shutting down {}", getClass.getName) }
}
