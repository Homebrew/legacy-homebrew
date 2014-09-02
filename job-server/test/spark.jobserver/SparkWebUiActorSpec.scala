package spark.jobserver

import akka.actor.{Props, ActorRef, ActorSystem}
import akka.io.IO
import akka.pattern.ask
import akka.testkit.{TestKit, ImplicitSender}
import com.typesafe.config.ConfigFactory
import org.scalatest.{FunSpec, BeforeAndAfter, BeforeAndAfterAll}
import org.scalatest.matchers.ShouldMatchers
import spray.client.pipelining._

import scala.concurrent.{Await, Future}
import scala.concurrent.duration._
import akka.util.Timeout
import akka.actor._
import spray.can.Http
import spray.http._
import HttpMethods._
import SparkWebUiActor._

import scala.util.{Failure, Success}

object SparkWebUiActorSpec {
  val sparkWebUrl = "localhost"
  val sparkWebPort = 8098
  val config = ConfigFactory.parseString(s"""
    spark {
      master = "spark://localhost:7077"
      webUrl = $sparkWebUrl
      webUrlPort = $sparkWebPort
      temp-contexts {
        num-cpu-cores = 4           # Number of cores to allocate.  Required.
        memory-per-node = 512m      # Executor memory per node, -Xmx style eg 512m, 1G, etc.
      }
      jobserver.job-result-cache-size = 100
      jobserver.context-creation-timeout = 5 s
      jobserver.context-factory = spark.jobserver.util.DefaultSparkContextFactory
      contexts {
        olap-demo {
          num-cpu-cores = 4
          memory-per-node = 512m
        }
      }
      context-settings {
        num-cpu-cores = 2
        memory-per-node = 512m
      }
    }
    akka.log-dead-letters = 0
                                         """)

  val system = ActorSystem("test", config)
}

/**
 * Created by senqiang on 8/22/14.
 */

// simple http service
class SimpleHttpServer extends Actor with ActorLogging {
  implicit val timeout: Timeout = 1.second // for the actor 'asks'
  import context.dispatcher // ExecutionContext for the futures and scheduler

  def receive = {
    // when a new connection comes in we register ourselves as the connection handler
    case _: Http.Connected => sender ! Http.Register(self)
    case HttpRequest(GET, Uri.Path("/"), _, _, _) =>  {
      sender ! HttpResponse(entity =
        """<td>ALIVE</td>
          |<td>DEAD</td>
        """.stripMargin)
    }
    case HttpRequest(GET, Uri.Path("/stop"), _, _, _) =>
      sender ! HttpResponse(entity = "Shutting down in 1 second ...")
      sender ! Http.Close
      context.system.scheduler.scheduleOnce(1.second) { context.system.shutdown() }
  }
}

class SparkWebUiActorSpec extends TestKit(SparkWebUiActorSpec.system) with ImplicitSender
  with FunSpec with ShouldMatchers with BeforeAndAfter with BeforeAndAfterAll {

  // Used in the asks (?) below to request info from contextSupervisor and resultActor
  implicit val ShortTimeout = Timeout(3 seconds)

  override def beforeAll(): Unit = {
    import akka.actor.{ActorSystem, Props}
    import akka.io.IO
    import spray.can.Http

    implicit val system = ActorSystem()
    // the handler actor replies to incoming HttpRequests
    val handler = system.actorOf(Props[SimpleHttpServer], name = "simpleHttpServer")
    IO(Http) ! Http.Bind(handler, interface = SparkWebUiActorSpec.sparkWebUrl, port = SparkWebUiActorSpec.sparkWebPort)
  }

  override def afterAll() {
    ooyala.common.akka.AkkaTestUtils.shutdownAndWait(SparkWebUiActorSpec.system)

    // close the web service
    implicit val system = ActorSystem("test")
    import system.dispatcher // execution context for futures below

    val pipeline: Future[SendReceive] =
      for (
        Http.HostConnectorInfo(connector, _) <-
        IO(Http) ? Http.HostConnectorSetup(SparkWebUiActorSpec.sparkWebUrl, port = SparkWebUiActorSpec.sparkWebPort)
      ) yield sendReceive(connector)

    val request = Get("/stop")
    pipeline.flatMap(_(request)) // async call

  }

  var actor: ActorRef = _

  before {
    actor = SparkWebUiActorSpec.system.actorOf(Props(classOf[SparkWebUiActor]), "spark-web-ui")
  }

  after {
    ooyala.common.akka.AkkaTestUtils.shutdownAndWait(actor)
  }

  describe("SparkWebUiActor") {
    it("should get worker info") {
      val future = actor ? GetWorkerStatus()
      val result = Await.result(future, ShortTimeout.duration).asInstanceOf[SparkWorkersInfo]
      result.alive should equal (1)
      result.dead should equal (1)
    }
  }
}