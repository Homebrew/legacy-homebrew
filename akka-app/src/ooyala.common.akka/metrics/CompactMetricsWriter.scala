package ooyala.common.akka.metrics

import com.yammer.metrics.core._
import com.yammer.metrics.Metrics
import org.slf4j.Logger
import java.util.concurrent.TimeUnit
import com.yammer.metrics.stats.Snapshot


/**
 * Writes out metrics in a form suitable for writing to log files. For example a counter will be written
 * out as
 * <pre>
 *   ooyala.common.akka.example.SomeActor.pending-futures(count = 20)
 * </pre>
 */
class CompactMetricsWriter(private val log: Logger) extends MetricProcessor[Logger] {

  import collection.JavaConverters._

  def process(registry: MetricsRegistry = Metrics.defaultRegistry()) {
    registry.allMetrics().asScala.foreach {
      case (metricName, metricsObject) => metricsObject.processWith(this, metricName, log)
    }
  }

  def processMeter(name: MetricName, meter: Metered, logger: Logger) {
    logger.info(processMetric(name) { sb => renderMeter(meter, sb) })
  }

  def processCounter(name: MetricName, counter: Counter, context: Logger) {
    context.info(processMetric(name) { sb =>
      sb.append("count = " + counter.count())
    })
  }

  def processHistogram(name: MetricName, histogram: Histogram, logger: Logger) {
    logger.info(processMetric(name) { sb => renderHistogram(histogram.getSnapshot, sb)})
  }

  def processTimer(name: MetricName, timer: Timer, logger: Logger) {
    logger.info(processMetric(name) { sb =>
      renderHistogram(timer.getSnapshot, sb, abbrev(timer.durationUnit()))
      sb.append(", ")
      renderMeter(timer, sb)
    })
  }

  def processGauge(name: MetricName, gauge: Gauge[_], context: Logger) {
    context.info(processMetric(name) { sb =>
      sb.append("gauge = " + gauge.value())
    })
  }

  private def processMetric(metricName: MetricName)(func: (StringBuilder) => Unit): String = {
    val sb = new StringBuilder()
    sb.append(metricName.getGroup + "." + metricName.getType + "." + metricName.getName + "(")
    func(sb)
    sb.append(")")
    sb.toString()
  }

  private def renderHistogram(snapshot: Snapshot, sb: StringBuilder, unit: String = "") {
    sb.append("median = " + "%2.2f%s".format(snapshot.getMedian, unit))
    sb.append(", p75 = " + "%2.2f%s".format(snapshot.get75thPercentile(), unit))
    sb.append(", p95 = " + "%2.2f%s".format(snapshot.get95thPercentile(), unit))
    sb.append(", p98 = " + "%2.2f%s".format(snapshot.get98thPercentile(), unit))
    sb.append(", p99 = " + "%2.2f%s".format(snapshot.get99thPercentile(), unit))
    sb.append(", p999 = " + "%2.2f%s".format(snapshot.get99thPercentile(), unit))
  }

  private def renderMeter(meter: Metered, sb: StringBuilder) {
    val unit = abbrev(meter.rateUnit())

    sb.append("count = " + meter.count)
    sb.append(", mean = " + "%2.2f/%s".format(meter.meanRate(), unit))
    sb.append(", m1 = " + "%2.2f/%s".format(meter.oneMinuteRate(), unit))
    sb.append(", m5 = " + "%2.2f/%s".format(meter.fiveMinuteRate(), unit))
    sb.append(", m15 = " + "%2.2f/%s".format(meter.fifteenMinuteRate(), unit))
  }

  private def abbrev(timeUnit: TimeUnit) = {
    timeUnit match {
      case TimeUnit.NANOSECONDS => "ns"
      case TimeUnit.MICROSECONDS => "us"
      case TimeUnit.MILLISECONDS => "ms"
      case TimeUnit.SECONDS => "s"
      case TimeUnit.MINUTES => "m"
      case TimeUnit.HOURS => "h"
      case TimeUnit.DAYS => "d"
      case _ =>
        throw new IllegalArgumentException("Unrecognized TimeUnit: " + timeUnit)
    }

  }
}
