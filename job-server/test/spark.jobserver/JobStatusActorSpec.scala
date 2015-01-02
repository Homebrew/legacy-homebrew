package spark.jobserver

import akka.actor.{Props, PoisonPill, ActorRef, ActorSystem}
import akka.testkit.{TestKit, ImplicitSender}
import spark.jobserver.io.{JarInfo, JobInfo, JobDAO}
import org.joda.time.DateTime
import org.scalatest.matchers.ShouldMatchers
import org.scalatest.{FunSpecLike, FunSpec, BeforeAndAfter, BeforeAndAfterAll}

object JobStatusActorSpec {
  val system = ActorSystem("test")
}

class JobStatusActorSpec extends TestKit(JobStatusActorSpec.system) with ImplicitSender
with FunSpecLike with ShouldMatchers with BeforeAndAfter with BeforeAndAfterAll {

  import com.typesafe.config._
  import CommonMessages._
  import JobStatusActor._

  private val jobId = "jobId"
  private val contextName = "contextName"
  private val appName = "appName"
  private val jarInfo = JarInfo(appName, DateTime.now)
  private val classPath = "classPath"
  private val jobInfo = JobInfo(jobId, contextName, jarInfo, classPath, DateTime.now, None, None)
  private val jobConfig = ConfigFactory.empty()

  override def afterAll() {
    ooyala.common.akka.AkkaTestUtils.shutdownAndWait(JobStatusActorSpec.system)
  }

  var actor: ActorRef = _
  var receiver: ActorRef = _
  var dao: JobDAO = _

  before {
    dao = new InMemoryDAO
    actor = system.actorOf(Props(classOf[JobStatusActor], dao))
    receiver = system.actorOf(Props[JobResultActor])
  }

  after {
    ooyala.common.akka.AkkaTestUtils.shutdownAndWait(actor)
  }

  describe("JobStatusActor") {
    it("should return empty sequence if there is no job infos") {
      actor ! GetRunningJobStatus
      expectMsg(Seq.empty)
    }

    it("should return error if non-existing job is unsubscribed") {
      actor ! Unsubscribe(jobId, receiver)
      expectMsg(NoSuchJobId)
    }

    it("should not initialize a job more than two times") {
      actor ! JobInit(jobInfo)
      actor ! JobInit(jobInfo)
      expectMsg(JobInitAlready)
    }

    it("should be informed JobStarted until it is unsubscribed") {
      actor ! JobInit(jobInfo)
      actor ! Subscribe(jobId, self, Set(classOf[JobStarted]))
      val msg = JobStarted(jobId, contextName, DateTime.now)
      actor ! msg
      expectMsg(msg)

      actor ! msg
      expectMsg(msg)

      actor ! Unsubscribe(jobId, self)
      actor ! JobStarted(jobId, contextName, DateTime.now)
      expectNoMsg()   // shouldn't get it again

      actor ! Unsubscribe(jobId, self)
      expectMsg(NoSuchJobId)
    }

    it("should be ok to subscribe beofore job init") {
      actor ! Subscribe(jobId, self, Set(classOf[JobStarted]))
      actor ! JobInit(jobInfo)
      val msg = JobStarted(jobId, contextName, DateTime.now)
      actor ! msg
      expectMsg(msg)
    }

    it("should be informed JobValidationFailed once") {
      actor ! JobInit(jobInfo)
      actor ! Subscribe(jobId, self, Set(classOf[JobValidationFailed]))
      val msg = JobValidationFailed(jobId, DateTime.now, new Throwable)
      actor ! msg
      expectMsg(msg)

      actor ! msg
      expectMsg(NoSuchJobId)
    }

    it("should be informed JobFinished until it is unsubscribed") {
      actor ! JobInit(jobInfo)
      actor ! JobStarted(jobId, contextName, DateTime.now)
      actor ! Subscribe(jobId, self, Set(classOf[JobFinished]))
      val msg = JobFinished(jobId, DateTime.now)
      actor ! msg
      expectMsg(msg)

      actor ! msg
      expectMsg(NoSuchJobId)
    }

    it("should be informed JobErroredOut until it is unsubscribed") {
      actor ! JobInit(jobInfo)
      actor ! JobStarted(jobId, contextName, DateTime.now)
      actor ! Subscribe(jobId, self, Set(classOf[JobErroredOut]))
      val msg = JobErroredOut(jobId, DateTime.now, new Throwable)
      actor ! msg
      expectMsg(msg)

      actor ! msg
      expectMsg(NoSuchJobId)
    }

    it("should update status correctly") {
      actor ! JobInit(jobInfo)
      actor ! GetRunningJobStatus
      expectMsg(Seq(jobInfo))

      val startTime = DateTime.now
      actor ! JobStarted(jobId, contextName, startTime)
      actor ! GetRunningJobStatus
      expectMsg(Seq(JobInfo(jobId, contextName, jarInfo, classPath, startTime, None, None)))

      val finishTIme = DateTime.now
      actor ! JobFinished(jobId, finishTIme)
      actor ! GetRunningJobStatus
      expectMsg(Seq.empty)
    }

    it("should update JobValidationFailed status correctly") {
      val initTime = DateTime.now
      val jobInfo = JobInfo(jobId, contextName, jarInfo, classPath, initTime, None, None)
      actor ! JobInit(jobInfo)

      val failedTime = DateTime.now
      val err = new Throwable
      actor ! JobValidationFailed(jobId, failedTime, err)
      actor ! GetRunningJobStatus
      expectMsg(Seq.empty)
    }

    it("should update JobErroredOut status correctly") {
      actor ! JobInit(jobInfo)

      val startTime = DateTime.now
      actor ! JobStarted(jobId, contextName, startTime)

      val failedTime = DateTime.now
      val err = new Throwable
      actor ! JobErroredOut(jobId, failedTime, err)
      actor ! GetRunningJobStatus
      expectMsg(Seq.empty)
    }
  }
}
