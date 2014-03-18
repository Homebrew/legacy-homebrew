package spark.jobserver

import akka.actor.ActorRef
import akka.util.Timeout
import org.apache.spark.rdd.RDD
import org.apache.spark.storage.StorageLevel
import scala.concurrent.Await

/**
 * An implementation of [[NamedRddSupport]] API for the Job Server.
 * Note that this contains code that executes on the same thread as the job.
 * Another part of this system is the rddManager, which is an actor which manages the concurrent
 * update of shared RDD state.
 */
class JobServerNamedRdds(val rddManager: ActorRef) extends NamedRdds {
  import RddManagerActorMessages._

  require(rddManager != null, "rddManager ActorRef must not be null!")

  def getOrElseCreate[T](name: String, rddGen: => RDD[T])
                        (implicit timeout: Timeout = defaultTimeout): RDD[T] = {
    import akka.pattern.ask

    val future = rddManager.ask(GetOrElseCreateRddRequest(name))(timeout)
    val result: RDD[T] = Await.result(future, timeout.duration) match {
      case Left(error: Throwable) =>
        throw new RuntimeException("Failed to get named RDD '" + name + "'", error)
      case Right(rdd: RDD[T]) => refreshRdd(rdd)
      case None =>
        // Try to generate the RDD and send the result of the operation to the rddManager.
        try {
          val rdd = createRdd(rddGen, name)
          rddManager ! CreateRddResult(name, Right(rdd))
          rdd
        } catch {
          case error: Throwable =>
            rddManager ! CreateRddResult(name, Left(error))
            throw new RuntimeException("Failed to create named RDD '" + name + "'", error)
        }
    }
    result
  }

  def get[T](name: String)(implicit timeout: Timeout = defaultTimeout): Option[RDD[T]] = {
    import akka.pattern.ask

    val future = rddManager ? GetRddRequest(name)
    Await.result(future, timeout.duration) match {
      case rddOpt: Option[RDD[T]] @unchecked => rddOpt.map { rdd => refreshRdd(rdd) }
    }
  }

  def update[T](name: String, rddGen: => RDD[T]): RDD[T] = {
    val rdd = createRdd(rddGen, name)
    rddManager ! CreateRddResult(name, Right(rdd))
    rdd
  }

  def destroy(name: String) {
    rddManager ! DestroyRdd(name)
  }

  def getNames()(implicit timeout: Timeout = defaultTimeout): Iterable[String] = {
    import akka.pattern.ask

    val future = rddManager ? GetRddNames
    Await.result(future, timeout.duration) match {
      case answer: Iterable[String] @unchecked => answer
    }
  }

  /**
   * Creates an RDD by calling the given generator, sets its name, persists it with the given storage level,
   * and optionally forces its contents to be computed.
   * @param rddGen a 0-ary function which will be called to generate the RDD in the caller's thread.
   * @param name the name to assign to the RDD.
   * @param storageLevel the storage level to persist the RDD with. Default: StorageLevel.MEMORY_ONLY.
   * @param forceComputation if true, forces the RDD to be computed by calling count().
   * @throws java.lang.IllegalArgumentException if forceComputation == true &&
   *                                               storageLevel == StorageLevel.NONE
   */
  private def createRdd[T](rddGen: => RDD[T],
                           name: String,
                           forceComputation: Boolean = true,
                           storageLevel: StorageLevel = defaultStorageLevel): RDD[T] = {
    require(!forceComputation || storageLevel != StorageLevel.NONE,
      "forceComputation implies storageLevel != NONE")
    val rdd = rddGen
    rdd.setName(name)
    if (storageLevel != StorageLevel.NONE) rdd.persist(storageLevel)
    // TODO: figure out if there is a better way to force the RDD to be computed
    if (forceComputation) rdd.count()
    rdd
  }

  /** Calls rdd.persist(), which updates the RDD's cached timestamp, meaning it won't get
   * garbage collected by Spark for some time.
   * @param rdd the RDD
   */
  private def refreshRdd[T](rdd: RDD[T]): RDD[T] = rdd.persist(rdd.getStorageLevel)
}
