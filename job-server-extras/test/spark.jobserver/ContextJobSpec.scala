package spark.jobserver

import com.typesafe.config.ConfigFactory
import scala.collection.mutable
import spark.jobserver.io.JobDAO

/**
 * This is just to test that you cannot load a SqlJob into a normal job context.
 */
object ContextJobSpec extends JobSpecConfig

class ContextJobSpec extends JobSpecBase(ContextJobSpec.getNewSystem) {
  import scala.concurrent.duration._
  import CommonMessages._
  import JobManagerSpec.MaxJobsPerContext

  val classPrefix = "spark.jobserver."
  private val sqlTestClass = classPrefix + "SqlLoaderJob"

  protected val emptyConfig = ConfigFactory.parseString("spark.master = bar")

  before {
    dao = new InMemoryDAO
    manager =
      system.actorOf(JobManagerActor.props(dao, "test", ContextJobSpec.config, false))
  }

  describe("error conditions") {
    it("should get WrongJobType if loading SQL job in a plain SparkContext context") {
      uploadTestJar()
      manager ! JobManagerActor.Initialize
      expectMsgClass(classOf[JobManagerActor.Initialized])
      manager ! JobManagerActor.StartJob("demo", sqlTestClass, emptyConfig, errorEvents)
      expectMsg(CommonMessages.WrongJobType)
    }
  }
}
