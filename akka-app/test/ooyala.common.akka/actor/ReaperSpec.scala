package ooyala.common.akka.actor


import akka.actor.{ActorSystem, Props, ActorRef}
import akka.testkit.{TestKit, ImplicitSender, TestProbe}
import org.scalatest.{MustMatchers, FunSpecLike, BeforeAndAfterAll}

// Our test reaper.  Sends the snooper a message when all
// the souls have been reaped
class TestReaper(snooper: ActorRef) extends Reaper {
  def allSoulsReaped(): Unit = snooper ! "Dead"
}

class ReaperSpec extends TestKit(ActorSystem("ReaperSpec")) with ImplicitSender
    with FunSpecLike
    with BeforeAndAfterAll
    with MustMatchers {

  import Reaper._
  import scala.concurrent.duration._

  override def afterAll() {
    system.shutdown()
  }

  describe("Reaper") {
    it("should not call allSoulsReaped if not all actors are done") {
      val a = TestProbe()
      val d = TestProbe()

      // Build our reaper
      val reaper = system.actorOf(Props(classOf[TestReaper], testActor))

      // Watch a couple
      reaper ! WatchMe(a.ref)
      reaper ! WatchMe(d.ref)

      // Stop one of them
      system.stop(a.ref)

      expectNoMsg(500 millis)
    }

    it("should detect that all actors can be reaped") {
      // Set up some dummy Actors
      val a = TestProbe()
      val d = TestProbe()

      // Build our reaper
      val reaper = system.actorOf(Props(classOf[TestReaper], testActor))

      // Watch a couple
      reaper ! WatchMe(a.ref)
      reaper ! WatchMe(d.ref)

      // Stop them
      system.stop(a.ref)
      system.stop(d.ref)

      // Make sure we've been called
      expectMsg("Dead")
    }
  }
}
