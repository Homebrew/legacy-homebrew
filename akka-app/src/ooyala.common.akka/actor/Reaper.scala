package ooyala.common.akka.actor

import akka.actor.{ActorRef, Terminated}
import scala.collection.mutable.ArrayBuffer
import ooyala.common.akka.InstrumentedActor

// Taken from http://letitcrash.com/post/30165507578/shutdown-patterns-in-akka-2

object Reaper {
  // Used by others to register an Actor for watching
  case class WatchMe(ref: ActorRef)
  case object Reaped
}

abstract class Reaper extends InstrumentedActor {
  import Reaper._

  // Keep track of what we're watching
  val watched = ArrayBuffer.empty[ActorRef]

  def allSoulsReaped(): Unit

  // Watch and check for termination
  override def wrappedReceive: Receive = {
    case Reaped =>
      watched.isEmpty

    case WatchMe(ref) =>
      logger.info("Watching actor {}", ref)
      context.watch(ref)
      watched += ref

    case Terminated(ref) =>
      logger.info("Actor {} terminated", ref)
      watched -= ref
      if (watched.isEmpty) allSoulsReaped()
  }
}

class ProductionReaper extends Reaper {
  def allSoulsReaped() {
    logger.warn("Shutting down actor system because all actors have terminated")
    context.system.shutdown()
  }
}

