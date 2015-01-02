package ooyala.common.akka.web

import java.util.concurrent.TimeUnit

import org.scalatest.{Matchers, FunSpec}
import spray.testkit.ScalatestRouteTest

import spray.http.StatusCodes._
import com.yammer.metrics.Metrics
import com.yammer.metrics.core.Gauge

class CommonRoutesSpec extends FunSpec with Matchers with ScalatestRouteTest with CommonRoutes {
  def actorRefFactory = system


  val metricCounter = Metrics.newCounter(getClass, "test-counter")
  val metricMeter = Metrics.newMeter(getClass, "test-meter", "requests", TimeUnit.SECONDS)
  val metricHistogram = Metrics.newHistogram(getClass, "test-hist")
  val metricTimer = Metrics.newTimer(getClass, "test-timer", TimeUnit.MILLISECONDS, TimeUnit.SECONDS)
  val metricGauge = Metrics.newGauge(getClass, "test-gauge", new Gauge[Int] {
    def value() = 10
  })

  val counterMap = Map("type" -> "counter", "count" -> 0)
  val gaugeMap = Map("type" -> "gauge", "value" -> 10)

  val meterMap = Map("type" -> "meter", "units" -> "seconds", "count" -> 0, "mean" -> 0.0,
    "m1" -> 0.0, "m5" -> 0.0, "m15" -> 0.0)
  val histMap = Map("type" -> "histogram", "median" -> 0.0, "p75" -> 0.0, "p95" -> 0.0,
    "p98" -> 0.0, "p99" -> 0.0, "p999" -> 0.0)
  val timerMap = Map("type" -> "timer", "rate" -> (meterMap - "type"),
    "duration" -> (histMap ++ Map("units" -> "milliseconds") - "type"))

  describe("/metricz route") {
    it("should report all metrics") {
      Get("/metricz") ~> commonRoutes ~> check {
        status === OK

        val metricsMap = JsonUtils.mapFromJson(responseAs[String])
        val classMetrics = metricsMap(getClass.getName).asInstanceOf[Map[String, Any]]

        classMetrics.keys.toSet should equal (Set("test-counter", "test-meter", "test-hist", "test-timer", "test-gauge"))
        classMetrics("test-counter") should equal (counterMap)
        classMetrics("test-meter") should equal (meterMap)
        classMetrics("test-hist") should equal (histMap)
        classMetrics("test-timer") should equal (timerMap)
      }
    }
  }

  describe("metrics serializer") {
    it("should serialize all metrics") {
      val flattenedMap = MetricsSerializer.asFlatMap()

      List("test-meter", "test-counter", "test-timer", "test-gauge", "test-hist") foreach { metricName =>
        flattenedMap.keys should contain("ooyala.common.akka.web.CommonRoutesSpec." + metricName)
      }

      flattenedMap("ooyala.common.akka.web.CommonRoutesSpec.test-meter") should equal(meterMap)
      flattenedMap("ooyala.common.akka.web.CommonRoutesSpec.test-counter") should equal(counterMap)
      flattenedMap("ooyala.common.akka.web.CommonRoutesSpec.test-hist") should equal(histMap)
      flattenedMap("ooyala.common.akka.web.CommonRoutesSpec.test-timer") should equal(timerMap)
      flattenedMap("ooyala.common.akka.web.CommonRoutesSpec.test-gauge") should equal(gaugeMap)
    }
  }
}
