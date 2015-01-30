package spark.jobserver

import akka.actor.ActorRef
import ooyala.common.akka.InstrumentedActor
import ooyala.common.akka.metrics.YammerMetrics
import org.apache.spark.rdd.RDD
import org.apache.spark.SparkContext
import scala.collection.mutable

object RddManagerActorMessages {
  // Message which asks to retrieve an RDD by name. If no such RDD is found, None will be returned.
  case class GetRddRequest(name: String)

  // Message which asks to retrieve an RDD by name. Different from GetRddRequest, because it tells the
  // RddManager that the client is willing to create the RDD with this name if one does not already exist.
  case class GetOrElseCreateRddRequest(name: String)

  // Message which tells the RddManager that a new RDD has been created, or that RDD generation failed.
  case class CreateRddResult(name: String, rddOrError: Either[Throwable, RDD[_]])

  // Message which tells the RddManager that an RDD should be destroyed and all of its cached blocks removed
  case class DestroyRdd(name: String)

  // Message which asks for the names of all RDDs currently managed by the RddManager
  case object GetRddNames
}

class RddManagerActor(sparkContext: SparkContext) extends InstrumentedActor with YammerMetrics {
  import RddManagerActorMessages._

  // we must store a reference to the RDD even though only its ID is used here
  // this reference prevents the RDD from being GCed and cleaned by sparks ContextCleaner
  private val namesToRDDs = new mutable.HashMap[String, RDD[_]]()
  private val waiters =
    new mutable.HashMap[String, mutable.Set[ActorRef]] with mutable.MultiMap[String, ActorRef]
  private val inProgress = mutable.Set[String]()

  def wrappedReceive: Receive = {
    case GetRddRequest(name) => sender ! getExistingRdd(name)

    case GetOrElseCreateRddRequest(name) if inProgress.contains(name) =>
      logger.info("RDD [{}] already being created, actor {} added to waiters list", name: Any, sender.path)
      waiters.addBinding(name, sender)

    case GetOrElseCreateRddRequest(name) => getExistingRdd(name) match {
      case Some(rdd) => sender ! Right(rdd)
      case None =>
        logger.info("RDD [{}] not found, starting creation", name)
        inProgress.add(name)
        sender ! None
    }

    // TODO: log the error?
    case CreateRddResult(name, Left(error)) => notifyAndClearWaiters(name, Left(error))

    case CreateRddResult(name, Right(rdd)) =>
      val oldRddOption = getExistingRdd(name)
      namesToRDDs(name) = rdd
      notifyAndClearWaiters(name, Right(rdd))
      // Note: unpersist the old rdd we just replaced, if there was one
      if (oldRddOption.isDefined && oldRddOption.get.id != rdd.id) {
        oldRddOption.get.unpersist(blocking = false)
      }

    case DestroyRdd(name) => getExistingRdd(name).foreach { rdd =>
      namesToRDDs.remove(name)
      rdd.unpersist(blocking = false)
    }

    case GetRddNames =>
      val persistentRdds = sparkContext.getPersistentRDDs
      val result = namesToRDDs.collect { case (name, rdd) if persistentRdds.contains(rdd.id) => name }
      // optimization: can remove stale names from our map if the SparkContext has unpersisted them.
      (namesToRDDs.keySet -- result).foreach { staleName => namesToRDDs.remove(staleName) }
      sender ! result
  }

  private def getExistingRdd(name: String): Option[RDD[_]] =
    namesToRDDs.get(name).flatMap { rdd => sparkContext.getPersistentRDDs.get(rdd.id) } match {
      case Some(rdd) => Some(rdd)
      case None =>
        // If this happens, maybe we never knew about this RDD, or maybe we had a name -> id mapping, but
        // spark's MetadataCleaner has evicted this RDD from the cache because it was too old, and we need
        // to forget about it. Remove it from our names -> ids map and respond as if we never knew about it.
        namesToRDDs.remove(name)
        None
    }

  private def notifyAndClearWaiters(name: String, message: Any) {
    waiters.get(name).foreach { actors => actors.foreach { actor => actor ! message } }
    waiters.remove(name) // Note: this removes all bindings for the key in the MultiMap
    inProgress.remove(name) // this RDD is no longer being computed, clear in progress flag
  }
}
