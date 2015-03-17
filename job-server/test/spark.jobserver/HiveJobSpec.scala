package spark.jobserver

import com.typesafe.config.ConfigFactory
import org.apache.spark.sql.catalyst.expressions.Row
import scala.collection.mutable
import spark.jobserver.io.JobDAO
import spark.jobserver.context.HiveContextFactory

object HiveJobSpec extends JobSpecConfig {
  override val contextFactory = classOf[HiveContextFactory].getName
}

class HiveJobSpec extends JobSpecBase(HiveJobSpec.getNewSystem) {
  import scala.concurrent.duration._
  import CommonMessages._
  import JobManagerSpec.MaxJobsPerContext

  val classPrefix = "spark.jobserver."
  private val hiveLoaderClass = classPrefix + "HiveLoaderJob"
  private val hiveQueryClass = classPrefix + "HiveTestJob"

  val emptyConfig = ConfigFactory.parseString("spark.master = bar")
  val queryConfig = ConfigFactory.parseString(
                      """sql = "SELECT firstName, lastName FROM `default.test_addresses` WHERE city = 'San Jose'" """)

  before {
    dao = new InMemoryDAO
    manager =
      system.actorOf(JobManagerActor.props(dao, "test", HiveJobSpec.config, false))
  }

  describe("Spark Hive Jobs") {
    it("should be able to create a Hive table, then query it using separate Hive-SQL jobs") {
      manager ! JobManagerActor.Initialize
      expectMsgClass(classOf[JobManagerActor.Initialized])

      uploadTestJar()
      manager ! JobManagerActor.StartJob("demo", hiveLoaderClass, emptyConfig, syncEvents ++ errorEvents)
      expectMsgPF(120 seconds, "Did not get JobResult") {
        case JobResult(_, result: Long) => result should equal (3L)
      }
      expectNoMsg()

      manager ! JobManagerActor.StartJob("demo", hiveQueryClass, queryConfig, syncEvents ++ errorEvents)
      expectMsgPF(6 seconds, "Did not get JobResult") {
        case JobResult(_, result: Array[Row]) =>
          result should have length (2)
          result(0)(0) should equal ("Bob")
      }
      expectNoMsg()
    }
  }
}
