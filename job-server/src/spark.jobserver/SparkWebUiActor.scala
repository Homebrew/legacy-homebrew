package spark.jobserver

import akka.actor.ActorSystem
import akka.io.IO
import akka.pattern.ask
import akka.util.Timeout
import ooyala.common.akka.InstrumentedActor
import scala.util.{Try, Success, Failure}
import scala.concurrent.Future
import spark.jobserver.SparkWebUiActor.{SparkWorkersErrorInfo, SparkWorkersInfo, GetWorkerStatus}
import spray.can.Http
import spray.client.pipelining.{Get, sendReceive, SendReceive}
import spray.http.HttpResponse

object SparkWebUiActor {
  // Requests
  case class GetWorkerStatus()

  // Responses
  case class SparkWorkersInfo(alive :Int, dead :Int)
  case class SparkWorkersErrorInfo(message :String)
}
/**
 * Created by senqiang on 8/13/14.
 */
class SparkWebUiActor extends InstrumentedActor {
  import actorSystem.dispatcher // execution context for futures
  import scala.concurrent.duration._

  implicit val actorSystem: ActorSystem = context.system

  // Used in the asks (?) below to request info from contextSupervisor and resultActor
  implicit val shortTimeout = Timeout(3 seconds)

  val config = context.system.settings.config

  val sparkWebHostUrl = Try(config.getString("spark.webUrl")).getOrElse("localhost")
  val sparkWebHostPort = Try(config.getInt("spark.webUrlPort")).getOrElse(8080)

  val pipeline: Future[SendReceive] =
    for (
      Http.HostConnectorInfo(connector, _) <-
        IO(Http) ? Http.HostConnectorSetup(sparkWebHostUrl, port = sparkWebHostPort)
    ) yield sendReceive(connector)

  override def postStop() {
    logger.info("Shutting down actor system for SparkWebUiActor")
  }

  override def wrappedReceive: Receive = {
    case GetWorkerStatus() =>
      val request = Get("/")
      logger.info("Get the request for spark web UI")

      val theSender = sender
      val responseFuture: Future[HttpResponse] = pipeline.flatMap(_(request))
      responseFuture onComplete {
        case Success(httpResponse) =>
          val content = httpResponse.entity.asString;

          val aliveWorkerNum = "<td>ALIVE</td>".r.findAllIn(content).length
          val deadWorkerNum = "<td>DEAD</td>".r.findAllIn(content).length

          theSender ! SparkWorkersInfo(aliveWorkerNum, deadWorkerNum)
        case Failure(error) =>
          val msg = s"Failed to retrieve Spark web UI $sparkWebHostUrl:$sparkWebHostPort"
          logger.error( msg )
          theSender ! SparkWorkersErrorInfo(msg)
      }
  }


}
