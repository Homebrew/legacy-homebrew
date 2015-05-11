package spark.jobserver

import java.io.File

import com.typesafe.config.ConfigFactory
import spark.jobserver.context.StreamingContextFactory
import spark.jobserver.io.JobInfo



object StreamingJobSpec extends JobSpecConfig {

  override val contextFactory = classOf[StreamingContextFactory].getName
}

class StreamingJobSpec extends JobSpecBase(StreamingJobSpec.getNewSystem) {

  import scala.concurrent.duration._
  import CommonMessages._

  import collection.JavaConverters._

  val classPrefix = "spark.jobserver."
  private val streamingJob = classPrefix + "StreamingTestJob"

  val configMap = Map("streaming.batch_interval" -> Integer.valueOf(3))

  val emptyConfig = ConfigFactory.parseMap(configMap.asJava)

  before {
    dao = new InMemoryDAO
    manager =
      system.actorOf(JobManagerActor.props(dao, "test", StreamingJobSpec.contextConfig, false))

  }

  describe("Spark Streaming Jobs") {
    it("should be able to process data usign Streaming jobs") {
      manager ! JobManagerActor.Initialize
      expectMsgClass(10 seconds, classOf[JobManagerActor.Initialized])
      uploadTestJar()
      manager ! JobManagerActor.StartJob("demo", streamingJob, emptyConfig, asyncEvents ++ errorEvents)

      val jobId = expectMsgPF(6 seconds, "Did not start JobResult") {
        case JobStarted(jobid, _, _) => {
          jobid should not be null
          jobid
        }
      }
      Thread sleep 6000
      dao.getJobInfos.get(jobId).get match  {
        case JobInfo(_, _, _, _, _, None, _) => {  }
        case e => fail("Unexpected JobInfo" + e)
      }

    }
  }
}
