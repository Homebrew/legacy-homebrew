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
   * Returns true if the job is valid for this context.
   * At the minimum this should check for if the job can actually take a context of this type;
   * for example, a SQLContext should only accept jobs that take a SQLContext.
   * The recommendation is to define a trait for each type of context job;  the standard
   * [[DefaultSparkContextFactory]] checks to see if the job is of type [[SparkJob]].
   */
  def isValidJob(job: SparkJobBase): Boolean

  /**
   * Responsible for performing any cleanup, including calling the underlying context's
   * stop method.
   */
  def stop()
}