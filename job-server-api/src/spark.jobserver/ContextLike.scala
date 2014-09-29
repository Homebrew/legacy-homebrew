package spark.jobserver

import org.apache.spark.SparkContext

/**
 * Represents a context based on SparkContext.  Examples include:
 * StreamingContext, SQLContext.
 *
 * The Job Server can spin up not just a vanilla SparkContext, but anything that
 * implements ContextLike.
 */
trait ContextLike {
  /**
   * The underlying SparkContext
   */
  def sparkContext: SparkContext

  /**
   * Responsible for performing any cleanup, including calling the underlying context's
   * stop method.
   */
  def stop()
}