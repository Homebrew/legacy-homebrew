package spark.jobserver.routes

import akka.actor.ActorRef
import akka.pattern.ask
import akka.util.Timeout
import spark.jobserver.DataManagerActor._
import spray.routing.{ HttpService, Route }
import spray.http.MediaTypes
import spray.http.StatusCodes
import java.net.URLDecoder
import spray.httpx.SprayJsonSupport.sprayJsonMarshaller
import spray.json.DefaultJsonProtocol._
import scala.concurrent.ExecutionContext

/**
 * Routes for listing, deletion of and storing data files
 *    GET /data                     - lists all currently stored files
 *    DELETE /data/<filename>       - deletes given file, no-op if file does not exist
 *    POST /data/<filename-prefix>  - upload a new data file, using the given prefix,
 *                                      a time stamp is appended to ensure uniqueness
 * @author TimMaltGermany
 */
trait DataRoutes extends HttpService {
  import scala.concurrent.duration._
  import spark.jobserver.WebApi._

  def dataRoutes(dataManager: ActorRef)(implicit ec: ExecutionContext, ShortTimeout: Timeout): Route = {
    // Get spray-json type classes for serializing Map[String, Any]
    import ooyala.common.akka.web.JsonUtils._

    // GET /data route returns a JSON map of the stored files and their upload time
    get { ctx =>
      val future = (dataManager ? ListData).mapTo[collection.Set[String]]
      future.map { names =>
        ctx.complete(names)
      }.recover {
        case e: Exception => ctx.complete(500, errMap(e, "ERROR"))
      }
    } ~
      // DELETE /data/filename delete the given file
      delete {
        path(Segment) { filename =>
          val future = dataManager ? DeleteData(URLDecoder.decode(filename, "UTF-8"))
          respondWithMediaType(MediaTypes.`application/json`) { ctx =>
            future.map {
              case Deleted => ctx.complete(StatusCodes.OK)
              case Error =>
                badRequest(ctx, "Unable to delete data file '" + filename + "'.")
            }.recover {
              case e: Exception => ctx.complete(500, errMap(e, "ERROR"))
            }
          }
        }
      } ~
      // POST /data/<filename>
      post {
        path(Segment) { filename =>
          entity(as[Array[Byte]]) { bytes =>
            val future = dataManager ? StoreData(filename, bytes)
            respondWithMediaType(MediaTypes.`application/json`) { ctx =>
              future.map {
                case Stored(filename) => {
                  ctx.complete(StatusCodes.OK, Map[String, Any](
                    ResultKey -> Map("filename" -> filename)))
                }
                case Error =>
                  badRequest(ctx, "Failed to store data file '" + filename + "'.")
              }.recover {
                case e: Exception => ctx.complete(500, errMap(e, "ERROR"))
              }
            }
          }
        }
      }
  }
}
