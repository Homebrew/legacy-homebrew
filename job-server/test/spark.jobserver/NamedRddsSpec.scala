package spark.jobserver

import akka.actor.{PoisonPill, Props, ActorRef, ActorSystem}
import akka.testkit.{ImplicitSender, TestKit}
import org.apache.spark.SparkContext
import org.scalatest.matchers.ShouldMatchers
import org.scalatest.{FunSpecLike, FunSpec, BeforeAndAfterAll, BeforeAndAfter}

class NamedRddsSpec extends TestKit(ActorSystem("NamedRddsSpec")) with FunSpecLike
with ImplicitSender with ShouldMatchers with BeforeAndAfter with BeforeAndAfterAll {
  System.setProperty("spark.cores.max", Runtime.getRuntime.availableProcessors.toString)
  System.setProperty("spark.executor.memory", "512m")
  System.setProperty("spark.akka.threads", Runtime.getRuntime.availableProcessors.toString)

  // To avoid Akka rebinding to the same port, since it doesn't unbind immediately on shutdown
  System.clearProperty("spark.driver.port")
  System.clearProperty("spark.hostPort")

  val sc = new SparkContext("local[4]", getClass.getSimpleName)
  val rddManager: ActorRef = system.actorOf(Props(classOf[RddManagerActor], sc))
  val namedRdds: NamedRdds = new JobServerNamedRdds(rddManager)

  before {
    namedRdds.getNames.foreach { rddName => namedRdds.destroy(rddName) }
  }

  override def afterAll() {
    ooyala.common.akka.AkkaTestUtils.shutdownAndWait(rddManager)
    sc.stop()
    ooyala.common.akka.AkkaTestUtils.shutdownAndWait(system)
  }

  describe("NamedRdds") {
    it("get() should return None when RDD does not exist") {
      namedRdds.get[Int]("No such RDD") should equal (None)
    }

    it("get() should return Some(RDD) when it exists") {
      val rdd = sc.parallelize(Seq(1, 2, 3))
      namedRdds.update("rdd1", rdd)
      namedRdds.get[Int]("rdd1") should equal (Some(rdd))
    }

    it("destroy() should do nothing when RDD with given name doesn't exist") {
      namedRdds.update("rdd1", sc.parallelize(Seq(1, 2, 3)))
      namedRdds.get[Int]("rdd1") should not equal None
      namedRdds.destroy("rdd2")
      namedRdds.get[Int]("rdd1") should not equal None
    }

    it("destroy() should destroy an RDD that exists") {
      namedRdds.update("rdd1", sc.parallelize(Seq(1, 2, 3)))
      namedRdds.get[Int]("rdd1") should not equal None
      namedRdds.destroy("rdd1")
      namedRdds.get[Int]("rdd1") should equal (None)
    }

    it("getNames() should return names of all managed RDDs") {
      namedRdds.getNames() should equal (Iterable())
      namedRdds.update("rdd1", sc.parallelize(Seq(1, 2, 3)))
      namedRdds.update("rdd2", sc.parallelize(Seq(4, 5, 6)))
      namedRdds.getNames().toSeq.sorted should equal (Seq("rdd1", "rdd2"))
      namedRdds.destroy("rdd1")
      namedRdds.getNames().toSeq.sorted should equal (Seq("rdd2"))
    }

    it("getOrElseCreate() should call generator function if RDD does not exist") {
      var generatorCalled = false
      val rdd = namedRdds.getOrElseCreate("rdd1", {
        generatorCalled = true
        sc.parallelize(Seq(1, 2, 3))
      })
      generatorCalled should equal (true)
    }

    it("getOrElseCreate() should not call generator function, should return existing RDD if one exists") {
      var generatorCalled = false
      val rdd = sc.parallelize(Seq(1, 2, 3))
      namedRdds.update("rdd1", rdd)
      val rdd2 = namedRdds.getOrElseCreate("rdd1", {
        generatorCalled = true
        sc.parallelize(Seq(4, 5, 6))
      })
      generatorCalled should equal (false)
      rdd2 should equal (rdd)
    }

    it("update() should replace existing RDD") {
      val rdd1 = sc.parallelize(Seq(1, 2, 3))
      val rdd2 = sc.parallelize(Seq(4, 5, 6))
      namedRdds.getOrElseCreate("rdd", rdd1) should equal (rdd1)
      namedRdds.update("rdd", rdd2)
      namedRdds.get[Int]("rdd") should equal (Some(rdd2))
    }

    it("should include underlying exception when error occurs") {
      def errorFunc = {
        throw new IllegalArgumentException("boo!")
        sc.parallelize(Seq(1, 2))
      }
      val err = intercept[RuntimeException] { namedRdds.getOrElseCreate("rdd", errorFunc) }
      err.getCause.getClass should equal (classOf[IllegalArgumentException])
    }
    // TODO: Add tests for parallel getOrElseCreate() calls
  }
}
