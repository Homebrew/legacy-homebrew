package spark.jobserver

import akka.actor.{ActorRef, ActorSystem, Props}
import akka.testkit.{ImplicitSender, TestKit}
import org.scalatest.{BeforeAndAfter, BeforeAndAfterAll, FunSpecLike, Matchers}


object JobResultActorSpec {
  val system = ActorSystem("test")
}

class JobResultActorSpec extends TestKit(JobResultActorSpec.system) with ImplicitSender
with FunSpecLike with Matchers with BeforeAndAfter with BeforeAndAfterAll {

  import spark.jobserver.CommonMessages._

  override def afterAll() {
    ooyala.common.akka.AkkaTestUtils.shutdownAndWait(JobResultActorSpec.system)
  }

  var actor: ActorRef = _

  // Create a new supervisor and FileDAO / working directory with every test, so the state of one test
  // never interferes with the other.
  before {
    actor = system.actorOf(Props[JobResultActor])
  }

  after {
    ooyala.common.akka.AkkaTestUtils.shutdownAndWait(actor)
  }

  describe("JobResultActor") {
    it("should return error if non-existing jobs are asked") {
      actor ! GetJobResult("jobId")
      expectMsg(NoSuchJobId)
    }

    it("should get back existing result") {
      actor ! JobResult("jobId", 10)
      actor ! GetJobResult("jobId")
      expectMsg(JobResult("jobId", 10))
    }

    it("should be informed only once by subscribed result") {
      actor ! Subscribe("jobId", self, Set(classOf[JobResult]))
      actor ! JobResult("jobId", 10)
      expectMsg(JobResult("jobId", 10))

      actor ! JobResult("jobId", 20)
      expectNoMsg()   // shouldn't get it again
    }

    it("should not be informed unsubscribed result") {
      actor ! Subscribe("jobId", self, Set(classOf[JobResult]))
      actor ! Unsubscribe("jobId", self)
      actor ! JobResult("jobId", 10)
      expectNoMsg()
    }

    it("should not publish if do not subscribe to JobResult events") {
      actor ! Subscribe("jobId", self, Set(classOf[JobValidationFailed], classOf[JobErroredOut]))
      actor ! JobResult("jobId", 10)
      expectNoMsg()
    }

    it("should return error if non-existing subscription is unsubscribed") {
      actor ! Unsubscribe("jobId", self)
      expectMsg(NoSuchJobId)
    }
  }


}
