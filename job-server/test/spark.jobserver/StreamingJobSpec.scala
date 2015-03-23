package spark.jobserver

import com.typesafe.config.ConfigFactory
import org.apache.spark.sql.catalyst.expressions.Row
import spark.jobserver.context.{StreamingContextFactory, SQLContextFactory}


object StreamingJobSpec extends JobSpecConfig {
  override val contextFactory = classOf[StreamingContextFactory].getName
}

class StreamingJobSpec extends JobSpecBase(StreamingJobSpec.getNewSystem) {
  import scala.concurrent.duration._
  import CommonMessages._
  import JobManagerSpec.MaxJobsPerContext

  import collection.JavaConverters._

  val classPrefix = "spark.jobserver."
  private val streamingJob = classPrefix + "StreamingTestJob"

  val configMap = Map("streaming.batch_interval" -> 3,
                      "test.file" -> "")

  val emptyConfig = ConfigFactory.parseMap(configMap.asJava)


  before {
    dao = new InMemoryDAO
    manager =
      system.actorOf(JobManagerActor.props(dao, "test", StreamingJobSpec.config, false))
  }

  describe("Spark Streaming Jobs") {
    it("should be able to process data usign Streaming jobs") {
      manager ! JobManagerActor.Initialize
      expectMsgClass(10 seconds, classOf[JobManagerActor.Initialized])

      uploadTestJar()
      manager ! JobManagerActor.StartJob("demo", streamingJob, emptyConfig, syncEvents ++ errorEvents)
      expectMsgPF(6 seconds, "Did not get JobResult") {
        case JobResult(_, result: Long) => result should equal (3L)
      }
      expectNoMsg()

    }
  }
}
