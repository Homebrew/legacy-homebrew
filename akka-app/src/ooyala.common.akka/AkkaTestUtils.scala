package ooyala.common.akka

import akka.actor.{ActorSystem, ActorRef}
import akka.pattern.gracefulStop
import scala.concurrent.Await

object AkkaTestUtils {
  import scala.concurrent.duration._

  // This is a var for now because we need to let people change it, and we can't pass this in as a param
  // because then we would change the API.  If we have it as a default param, we can't have multiple methods
  // with the same name.
  var timeout = 15 seconds

  def shutdownAndWait(actor: ActorRef) {
    if (actor != null) {
      val stopped = gracefulStop(actor, timeout)
      Await.result(stopped, timeout + (1 seconds))
    }
  }

  def shutdownAndWait(system: ActorSystem) {
    if (system != null) {
      system.shutdown()
      system.awaitTermination(timeout)
    }
  }
}
