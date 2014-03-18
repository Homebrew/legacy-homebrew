package spark.jobserver

import akka.util.Timeout
import java.lang.ThreadLocal
import java.util.concurrent.atomic.AtomicReference
import org.apache.spark.rdd.RDD
import org.apache.spark.storage.StorageLevel
import scala.concurrent.duration.Duration

/**
 * NamedRdds - a trait that gives you safe, concurrent creation and access to named RDDs
 * (the native SparkContext interface only has access to RDDs by numbers).
 * It facilitates easy sharing of RDDs amongst jobs sharing the same SparkContext.
 * If two jobs simultaneously tries to create an RDD with the same name,
 * only one will win and the other will retrieve the same one.
 *
 * Note that to take advantage of NamedRddSupport, a job must mix this in and use the APIs here instead of
 * the native RDD `cache()`, otherwise we will not know about the names.
 */
trait NamedRdds {
  // Default timeout is 60 seconds. Hopefully that is enough to let most RDD generator functions finish.
  val defaultTimeout = akka.util.Timeout(Duration(60, java.util.concurrent.TimeUnit.SECONDS))

  // Default level to cache RDDs at.
  val defaultStorageLevel = StorageLevel.MEMORY_ONLY

  /**
   * Gets an RDD with the given name, or creates it if one doesn't already exist.
   *
   * If the given RDD has already been computed by another job and cached in memory, this method will return
   * a reference to the cached RDD. If the RDD has never been computed, then the generator will be called
   * to compute it, in the caller's thread, and the result will be cached and returned to the caller.
   *
   * If an RDD is requested by thread B while thread A is generating the RDD, thread B will block up to
   * the duration specified by @timeout. If thread A finishes generating the RDD within that time, then
   * thread B will get a reference to the newly-created RDD. If thread A does not finish generating the
   * RDD within that time, then thread B will throw a timeout exception.
   *
   * @param name the unique name of the RDD. The uniqueness is scoped to the current SparkContext.
   * @param rddGen a 0-ary function which will generate the RDD if it doesn't already exist.
   * @param timeout if the RddManager doesn't respond within this timeout, an error will be thrown.
   * @tparam T the generic type of the RDD.
   * @return the RDD with the given name.
   * @throws java.util.concurrent.TimeoutException if the request to the RddManager times out.
   * @throws java.lang.RuntimeException wrapping any error that occurs within the generator function.
   */
  def getOrElseCreate[T](name: String, rddGen: => RDD[T])
                        (implicit timeout: Timeout = defaultTimeout): RDD[T]

  /**
   * Gets an RDD with the given name if it already exists and is cached by the RddManager.
   * If the RDD does not exist, None is returned.
   *
   * Note that a previously-known RDD could 'disappear' if it hasn't been used for a while, because the
   * SparkContext garbage-collects old cached RDDs.
   *
   * @param name the unique name of the RDD. The uniqueness is scoped to the current SparkContext.
   * @param timeout if the RddManager doesn't respond within this timeout, an error will be thrown.
   * @tparam T the generic type of the RDD.
   * @return the RDD with the given name.
   * @throws java.util.concurrent.TimeoutException if the request to the RddManager times out.
   */
  def get[T](name: String)(implicit timeout: Timeout = defaultTimeout): Option[RDD[T]]

  /**
   * Replaces an existing RDD with a given name with a new RDD. If an old RDD for the given name existed,
   * it is un-persisted (non-blocking) and destroyed. It is safe to call this method when there is no
   * existing RDD with the given name. If multiple threads call this around the same time, the end result
   * is undefined - one of the generated RDDs will win and will be returned from future calls to get().
   *
   * The rdd generator function will be called from the caller's thread. Note that if this is called at the
   * same time as getOrElseCreate() for the same name, and completes before the getOrElseCreate() call,
   * then threads waiting for the result of getOrElseCreate() will unblock with the result of this
   * update() call. When the getOrElseCreate() succeeds, it will replace the result of this update() call.
   *
   * @param name the unique name of the RDD. The uniqueness is scoped to the current SparkContext.
   * @param rddGen a 0-ary function which will be called to generate the RDD in the caller's thread.
   * @tparam T the generic type of the RDD.
   * @return the RDD with the given name.
   */
  def update[T](name: String, rddGen: => RDD[T]): RDD[T]

  /**
   * Destroys an RDD with the given name, if one existed. Has no effect if no RDD with this name exists.
   *
   * @param name the unique name of the RDD. The uniqueness is scoped to the current SparkContext.
   */
  def destroy(name: String): Unit

  /**
   * Returns the names of all named RDDs that are managed by the RddManager.
   *
   * Note: this returns a snapshot of RDD names at one point in time. The caller should always expect
   * that the data returned from this method may be stale and incorrect.

   * @param timeout if the RddManager doesn't respond within this timeout, an error will be thrown.
   * @return a collection of RDD names representing RDDs managed by the RddManager.
   */
  def getNames()(implicit timeout: Timeout = defaultTimeout): Iterable[String]
}

trait NamedRddSupport { self: SparkJob =>
  // Note: the JobManagerActor sets the correct NamedRdds instance here before before running our job.
  val namedRddsPrivate: AtomicReference[NamedRdds] = new AtomicReference[NamedRdds](null)

  def namedRdds: NamedRdds = namedRddsPrivate.get() match {
    case null => throw new NullPointerException("namedRdds value is null!")
    case rdds: NamedRdds => rdds
  }
}
