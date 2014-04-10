package spark.jobserver

import akka.actor.{Props, ActorRef, ActorSystem}
import akka.testkit.{TestKit, ImplicitSender}
import org.scalatest.{FunSpec, BeforeAndAfter, BeforeAndAfterAll}
import org.scalatest.matchers.ShouldMatchers
import spark.jobserver.io.{JobDAO, JobInfo}

object JobInfoActorSpec {
  val system = ActorSystem("test")
}

class JobInfoActorSpec extends TestKit(JobInfoActorSpec.system) with ImplicitSender
with FunSpec with ShouldMatchers with BeforeAndAfter with BeforeAndAfterAll {

  import com.typesafe.config._
  import CommonMessages.NoSuchJobId
  import JobInfoActor._

  private val jobId = "jobId"
  private val jobConfig = ConfigFactory.empty()

  override def afterAll() {
    ooyala.common.akka.AkkaTestUtils.shutdownAndWait(JobInfoActorSpec.system)
  }

  var actor: ActorRef = _
  var dao: JobDAO = _

  before {
    dao = new InMemoryDAO
    actor = system.actorOf(Props(classOf[JobInfoActor], dao, system.actorOf(Props(classOf[LocalContextSupervisorActor], dao))))
  }

  after {
    ooyala.common.akka.AkkaTestUtils.shutdownAndWait(actor)
  }

  describe("JobInfoActorSpec") {
    it("should return a job configuration when the jobId exists") {
      dao.saveJobInfo(JobInfo(jobId, "", null, "", null, None, jobConfig, None))
      actor ! GetJobConfig(jobId)
      expectMsg(jobConfig)
    }

    it("should return error if jobId does not exist") {
      actor ! GetJobConfig(jobId)
      expectMsg(NoSuchJobId)
    }
  }
}
