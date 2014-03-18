package spark.jobserver.util

import java.util.Map.Entry
import java.lang.ref.SoftReference

/**
 * A convenience class to define a Least-Recently-Used Cache with a maximum size.
 * The oldest entries by time of last access will be removed when the number of entries exceeds
 * cacheSize.
 * For definitions of cacheSize and loadingFactor, see the docs for java.util.LinkedHashMap
 * @see LinkedHashMap
 */
class LRUCache[K, V](cacheSize: Int, loadingFactor: Float  = 0.75F) {

  private val cache = {
    val initialCapacity = math.ceil(cacheSize / loadingFactor).toInt + 1
    new java.util.LinkedHashMap[K, V](initialCapacity, loadingFactor, true) {
      protected override def removeEldestEntry(p1: Entry[K, V]): Boolean = size() > cacheSize
    }
  }

  private var cacheMiss = 0
  private var cacheHit = 0

  /** size of the cache. This is an exact number and runs in constant time */
  def size: Int = cache.size()

  /** @return TRUE if the cache contains the key */
  def containsKey(k: K): Boolean = cache.get(k) != null

  /** @return the value in cache or load a new value into cache */
  def get(k: K, v: => V): V = {
    cache.get(k) match {
      case null =>
        val evaluatedV = v
        cache.put(k, evaluatedV)
        cacheMiss += 1
        evaluatedV
      case vv =>
        cacheHit += 1
        vv
    }
  }

  def cacheHitRatio: Double = cacheMiss.toDouble / math.max(cacheMiss + cacheHit, 1)

  def put(k: K, v: V): V = cache.put(k, v)

  def get(k: K): Option[V] = Option(cache.get(k))
}
