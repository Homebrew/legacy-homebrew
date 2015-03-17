package spark.jobserver

import com.typesafe.config.ConfigFactory
import org.apache.spark.sql.catalyst.expressions.Row
import scala.collection.mutable
import spark.jobserver.io.JobDAO
import spark.jobserver.context.SQLContextFactory

object SqlJobSpec extends JobSpecConfig {
  override val contextFactory = classOf[SQLContextFactory].getName
}

class SqlJobSpec extends JobSpecBase(SqlJobSpec.getNewSystem) {
  import scala.concurrent.duration._
  import CommonMessages._
  import JobManagerSpec.MaxJobsPerContext

  val classPrefix = "spark.jobserver."
  private val sqlLoaderClass = classPrefix + "SqlLoaderJob"
  private val sqlQueryClass = classPrefix + "SqlTestJob"

  val emptyConfig = ConfigFactory.parseString("spark.master = bar")
  val queryConfig = ConfigFactory.parseString(
                      """sql = "SELECT firstName, lastName FROM addresses WHERE city = 'San Jose'" """)

  before {
    dao = new InMemoryDAO
    manager =
      system.actorOf(JobManagerActor.props(dao, "test", SqlJobSpec.config, false))
  }

  describe("Spark SQL Jobs") {
    it("should be able to create and cache a table, then query it using separate SQL jobs") {
      manager ! JobManagerActor.Initialize
      expectMsgClass(classOf[JobManagerActor.Initialized])

      uploadTestJar()
      manager ! JobManagerActor.StartJob("demo", sqlLoaderClass, emptyConfig, syncEvents ++ errorEvents)
      expectMsgPF(3 seconds, "Did not get JobResult") {
        case JobResult(_, result: Long) => result should equal (3L)
      }
      expectNoMsg()

      manager ! JobManagerActor.StartJob("demo", sqlQueryClass, queryConfig, syncEvents ++ errorEvents)
      expectMsgPF(3 seconds, "Did not get JobResult") {
        case JobResult(_, result: Array[Row]) =>
          result should have length (2)
          result(0)(0) should equal ("Bob")
      }
      expectNoMsg()
    }
  }
}
