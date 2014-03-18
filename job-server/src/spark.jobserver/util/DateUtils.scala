package spark.jobserver.util

import org.joda.time.format.ISODateTimeFormat
import org.joda.time.{DateTime, DateTimeComparator, DateTimeZone}


object DateUtils {
  val ZeroTime = dtFromUtcSeconds(0)

  private val iso8601format = ISODateTimeFormat.dateTimeNoMillis()
  private val iso8601withMillis = ISODateTimeFormat.dateTime()
  private val dateComparator = DateTimeComparator.getInstance()

  def iso8601(dt: DateTime, fractions: Boolean = false): String =
    if (fractions) iso8601withMillis.print(dt) else iso8601format.print(dt)

  @inline def dtFromUtcSeconds(seconds: Int): DateTime = new DateTime(seconds * 1000L, DateTimeZone.UTC)

  @inline def dtFromIso8601(isoString: String): DateTime = new DateTime(isoString, DateTimeZone.UTC)

  /**
   * Implicit conversions so we can use Scala comparison operators
   * with JodaTime's DateTime
   */
  implicit def dateTimeToScalaWrapper(dt: DateTime): DateTimeWrapper = new DateTimeWrapper(dt)

  class DateTimeWrapper(dt: DateTime) extends Ordered[DateTime] with Ordering[DateTime] {
    def compare(that: DateTime): Int = dateComparator.compare(dt, that)
    def compare(a: DateTime, b: DateTime): Int = dateComparator.compare(a, b)
  }
}
