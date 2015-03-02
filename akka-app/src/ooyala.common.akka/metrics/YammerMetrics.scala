package ooyala.common.akka.metrics

import com.yammer.metrics.Metrics
import com.yammer.metrics.core.{Histogram, Meter, Gauge, Timer}
import java.util.concurrent.TimeUnit

/**
 * Utility trait to make metrics creation slightly less verbose
 */
trait YammerMetrics {
  def meter(name: String, eventType: String): Meter =
    Metrics.newMeter(getClass, name, eventType, TimeUnit.SECONDS)

  def gauge[T](name: String, metric: => T, scope: String = null): Gauge[T] =
    Metrics.newGauge(getClass, name, scope, new Gauge[T] {
      override def value(): T = metric
    })

  def histogram(name: String): Histogram = Metrics.newHistogram(getClass, name, true)

  def timer(name: String,
            durationUnit: TimeUnit = TimeUnit.NANOSECONDS,
            rateUnit: TimeUnit = TimeUnit.SECONDS): Timer =
    Metrics.newTimer(getClass, name, durationUnit, rateUnit)
}
