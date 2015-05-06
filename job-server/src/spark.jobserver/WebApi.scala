package spark.jobserver

import akka.actor.{ ActorSystem, ActorRef }
import akka.pattern.ask
import akka.util.Timeout
import com.typesafe.config.{ Config, ConfigFactory, ConfigException, ConfigRenderOptions }
import java.util.NoSuchElementException
import ooyala.common.akka.web.{ WebService, CommonRoutes }
import org.joda.time.DateTime
import org.slf4j.LoggerFactory
import spark.jobserver.util.SparkJobUtils
import scala.concurrent.{Await, ExecutionContext}
import scala.util.Try
import spark.jobserver.io.JobInfo
import spray.http.HttpResponse
import spray.http.MediaTypes
import spray.http.StatusCodes
import spray.httpx.SprayJsonSupport.sprayJsonMarshaller
import spray.json.DefaultJsonProtocol._
import spray.routing.{ HttpService, Route, RequestContext }

class WebApi(system: ActorSystem,
             config: Config,
             port: Int,
             jarManager: ActorRef,
             supervisor: ActorRef,
             jobInfo: ActorRef)
    extends HttpService with CommonRoutes {
  import CommonMessages._
  import ContextSupervisor._
  import scala.concurrent.duration._

  // Get spray-json type classes for serializing Map[String, Any]
  import ooyala.common.akka.web.JsonUtils._

  override def actorRefFactory: ActorSystem = system
  implicit val ec: ExecutionContext = system.dispatcher
  implicit val ShortTimeout = Timeout(3 seconds)
  val DefaultSyncTimeout = Timeout(10 seconds)
  val DefaultJobLimit = 50
  val StatusKey = "status"
  val ResultKey = "result"

  val contextTimeout = SparkJobUtils.getContextTimeout(config)
  val sparkAliveWorkerThreshold = Try(config.getInt("spark.jobserver.sparkAliveWorkerThreshold")).getOrElse(1)
  val bindAddress = config.getString("spark.jobserver.bind-address")

  val logger = LoggerFactory.getLogger(getClass)

  val myRoutes = jarRoutes ~ contextRoutes ~ jobRoutes ~ healthzRoutes ~ otherRoutes

  def start() {
    logger.info("Starting browser web service...")
    WebService.start(myRoutes ~ commonRoutes, system, bindAddress, port)
  }

  /**
   * Routes for listing and uploading jars
   *    GET /jars              - lists all current jars
   *    POST /jars/<appName>   - upload a new jar file
   */
  def jarRoutes: Route = pathPrefix("jars") {
    // GET /jars route returns a JSON map of the app name and the last time a jar was uploaded.
    get { ctx =>
      val future = (jarManager ? ListJars).mapTo[collection.Map[String, DateTime]]
      future.map { jarTimeMap =>
        val stringTimeMap = jarTimeMap.map { case (app, dt) => (app, dt.toString()) }.toMap
        ctx.complete(stringTimeMap)
      }.recover {
        case e: Exception => ctx.complete(500, errMap(e, "ERROR"))
      }
    } ~
      // POST /jars/<appName>
      // The <appName> needs to be unique; uploading a jar with the same appName will replace it.
      post {
        path(Segment) { appName =>
          entity(as[Array[Byte]]) { jarBytes =>
            val future = jarManager ? StoreJar(appName, jarBytes)
            respondWithMediaType(MediaTypes.`application/json`) { ctx =>
              future.map {
                case JarStored  => ctx.complete(StatusCodes.OK)
                case InvalidJar => badRequest(ctx, "Jar is not of the right format")
              }.recover {
                case e: Exception => ctx.complete(500, errMap(e, "ERROR"))
              }
            }
          }
        }
      }
  }

  /**
   * Routes for listing, adding, and stopping contexts
   *     GET /contexts         - lists all current contexts
   *     POST /contexts/<contextName> - creates a new context
   *     DELETE /contexts/<contextName> - stops a context and all jobs running in it
   */
  def contextRoutes: Route = pathPrefix("contexts") {
    import ContextSupervisor._
    import collection.JavaConverters._
    get { ctx =>
      (supervisor ? ListContexts).mapTo[Seq[String]]
        .map { contexts => ctx.complete(contexts) }
    } ~
      post {
        /**
         *  POST /contexts/<contextName>?<optional params> -
         *    Creates a long-running context with contextName and options for context creation
         *    All options are merged into the defaults in spark.context-settings
         *
         * @optional @param num-cpu-cores Int - Number of cores the context will use
         * @optional @param memory-per-node String - -Xmx style string (512m, 1g, etc) for max memory per node
         * @return the string "OK", or error if context exists or could not be initialized
         */
        path(Segment) { (contextName) =>
          // Enforce user context name to start with letters
          if (!contextName.head.isLetter) {
            complete(StatusCodes.BadRequest, errMap("context name must start with letters"))
          } else {
            parameterMap { (params) =>
              val config = ConfigFactory.parseMap(params.asJava)
              val future = (supervisor ? AddContext(contextName, config))(contextTimeout.seconds)
              respondWithMediaType(MediaTypes.`application/json`) { ctx =>
                future.map {
                  case ContextInitialized   => ctx.complete(StatusCodes.OK)
                  case ContextAlreadyExists => badRequest(ctx, "context " + contextName + " exists")
                  case ContextInitError(e)  => ctx.complete(500, errMap(e, "CONTEXT INIT ERROR"))
                }
              }
            }
          }
        }
      } ~
      delete {
        //  DELETE /contexts/<contextName>
        //  Stop the context with the given name.  Executors will be shut down and all cached RDDs
        //  and currently running jobs will be lost.  Use with care!
        path(Segment) { (contextName) =>
          val future = supervisor ? StopContext(contextName)
          respondWithMediaType(MediaTypes.`text/plain`) { ctx =>
            future.map {
              case ContextStopped => ctx.complete(StatusCodes.OK)
              case NoSuchContext  => notFound(ctx, "context " + contextName + " not found")
            }
          }
        }
      }
  }

  /**
   * Routes for getting health status of job server
   *    GET /healthz              - return OK or error message
   */
  def healthzRoutes: Route = pathPrefix("healthz") {
    get { ctx =>
      logger.info("Receiving healthz check request")
      ctx.complete("OK")
    }
  }

  def otherRoutes: Route = get {
    implicit val ar = actorRefFactory

    path("") {
      // Main index.html page
      getFromResource("html/index.html")
    } ~ pathPrefix("html") {
      // Static files needed by index.html
      getFromResourceDirectory("html")
    }
  }

  val errorEvents: Set[Class[_]] = Set(classOf[JobErroredOut], classOf[JobValidationFailed])
  val asyncEvents = Set(classOf[JobStarted]) ++ errorEvents
  val syncEvents = Set(classOf[JobResult]) ++ errorEvents

  /**
   * Main routes for starting a job, listing existing jobs, getting job results
   */
  def jobRoutes: Route = pathPrefix("jobs") {
    import JobInfoActor._
    import JobManagerActor._

    /**
     * GET /jobs/<jobId>/config -- returns the configuration used to launch this job or an error if not found.
     *
     * @required @param jobId
     */
    (get & path(Segment / "config")) { jobId =>
      val renderOptions = ConfigRenderOptions.defaults().setComments(false).setOriginComments(false)

      val future = jobInfo ? GetJobConfig(jobId)
      respondWithMediaType(MediaTypes.`application/json`) { ctx =>
        future.map {
          case NoSuchJobId =>
            notFound(ctx, "No such job ID " + jobId.toString)
          case cnf: Config =>
            ctx.complete(cnf.root().render(renderOptions))
        }
      }
    } ~
      // GET /jobs/<jobId>  returns the result in JSON form in a table
      //  JSON result always starts with: {"status": "ERROR" / "OK" / "RUNNING"}
      // If the job isn't finished yet, then {"status": "RUNNING" | "ERROR"} is returned.
      (get & path(Segment)) { jobId =>
        val future = jobInfo ? GetJobResult(jobId)
        respondWithMediaType(MediaTypes.`application/json`) { ctx =>
          future.map {
            case NoSuchJobId =>
              notFound(ctx, "No such job ID " + jobId.toString)
            case JobInfo(_, _, _, _, _, None, _) =>
              ctx.complete(Map(StatusKey -> "RUNNING"))
            case JobInfo(_, _, _, _, _, _, Some(ex)) =>
              ctx.complete(Map(StatusKey -> "ERROR", "ERROR" -> formatException(ex)))
            case JobResult(_, result) =>
              ctx.complete(resultToTable(result))
          }
        }
      } ~
        //  DELETE /jobs/<jobId>
        //  Stop the current job. All other jobs submited with this spark context
        //  will continue to run
      (delete & path(Segment)) { jobId =>
          val future = jobInfo ? GetJobResult(jobId)
          respondWithMediaType(MediaTypes.`application/json`) { ctx =>
            future.map {
              case NoSuchJobId =>
                notFound(ctx, "No such job ID " + jobId.toString)
              case JobInfo(_, contextName, _, classPath, _, None, _) =>
                val jobManager = getJobManagerForContext(Some(contextName), config, classPath)
                jobManager.get ! KillJob(jobId)
                ctx.complete(Map(StatusKey -> "KILLED"))
              case JobInfo(_, _, _, _, _, _, Some(ex)) =>
                ctx.complete(Map(StatusKey -> "ERROR", "ERROR" -> formatException(ex)))
              case JobResult(_, result) =>
                ctx.complete(resultToTable(result))
            }
          }
        } ~
      /**
       * GET /jobs   -- returns a JSON list of hashes containing job status, ex:
       * [
       *   {jobId: "word-count-2013-04-22", status: "RUNNING"}
       * ]
       * @optional @param limit Int - optional limit to number of jobs to display, defaults to 50
       */
      get {
        parameters('limit.as[Int] ?) { (limitOpt) =>
          val limit = limitOpt.getOrElse(DefaultJobLimit)
          val future = (jobInfo ? GetJobStatuses(Some(limit))).mapTo[Seq[JobInfo]]
          respondWithMediaType(MediaTypes.`application/json`) { ctx =>
            future.map { infos =>
              val jobReport = infos.map { info =>
                Map("jobId" -> info.jobId,
                  "startTime" -> info.startTime.toString(),
                  "classPath" -> info.classPath,
                  "context"   -> (if (info.contextName.isEmpty) "<<ad-hoc>>" else info.contextName),
                  "duration" -> getJobDurationString(info)) ++ (info match {
                    case JobInfo(_, _, _, _, _, None, _)       => Map(StatusKey -> "RUNNING")
                    case JobInfo(_, _, _, _, _, _, Some(ex))   => Map(StatusKey -> "ERROR",
                                                                      ResultKey -> formatException(ex))
                    case JobInfo(_, _, _, _, _, Some(e), None) => Map(StatusKey -> "FINISHED")
                  })
              }
              ctx.complete(jobReport)
            }
          }
        }
      } ~
      /**
       * POST /jobs   -- Starts a new job.  The job JAR must have been previously uploaded, and
       *                 the classpath must refer to an object that implements SparkJob.  The `validate()`
       *                 API will be invoked before `runJob`.
       *
       * @entity         The POST entity should be a Typesafe Config format file;
       *                 It will be merged with the job server's config file at startup.
       * @required @param appName String - the appName for the job JAR
       * @required @param classPath String - the fully qualified class path for the job
       * @optional @param context String - the name of the context to run the job under.  If not specified,
       *                                   then a temporary context is allocated for the job
       * @optional @param sync Boolean if "true", then wait for and return results, otherwise return job Id
       * @optional @param timeout Int - the number of seconds to wait for sync results to come back
       * @return JSON result of { StatusKey -> "OK" | "ERROR", ResultKey -> "result"}, where "result" is
       *         either the job id, or a result
       */
      post {
        entity(as[String]) { configString =>
          parameters('appName, 'classPath,
            'context ?, 'sync.as[Boolean] ?, 'timeout.as[Int] ?) {
            (appName, classPath, contextOpt, syncOpt, timeoutOpt) =>
              try {
                val async = !syncOpt.getOrElse(false)
                val postedJobConfig = ConfigFactory.parseString(configString)
                val jobConfig = postedJobConfig.withFallback(config)
                val contextConfig = Try(jobConfig.getConfig("spark.context-settings")).
                                      getOrElse(ConfigFactory.empty)
                val jobManager = getJobManagerForContext(contextOpt, contextConfig, classPath)
                val events = if (async) asyncEvents else syncEvents
                val timeout = timeoutOpt.map(t => Timeout(t.seconds)).getOrElse(DefaultSyncTimeout)
                val future = jobManager.get.ask(
                  JobManagerActor.StartJob(appName, classPath, jobConfig, events))(timeout)
                respondWithMediaType(MediaTypes.`application/json`) { ctx =>
                  future.map {
                    case JobResult(_, res)       => ctx.complete(resultToTable(res))
                    case JobErroredOut(_, _, ex) => ctx.complete(errMap(ex, "ERROR"))
                    case JobStarted(jobId, context, _) =>
                      jobInfo ! StoreJobConfig(jobId, postedJobConfig)
                      ctx.complete(202, Map[String, Any](
                                          StatusKey -> "STARTED",
                                          ResultKey -> Map("jobId" -> jobId, "context" -> context)))
                    case JobValidationFailed(_, _, ex) =>
                      ctx.complete(400, errMap(ex, "VALIDATION FAILED"))
                    case NoSuchApplication => notFound(ctx, "appName " + appName + " not found")
                    case NoSuchClass       => notFound(ctx, "classPath " + classPath + " not found")
                    case WrongJobType      =>
                      ctx.complete(400, errMap("Invalid job type for this context"))
                    case JobLoadingError(err) =>
                      ctx.complete(500, errMap(err, "JOB LOADING FAILED"))
                    case NoJobSlotsAvailable(maxJobSlots) =>
                      val errorMsg = "Too many running jobs (" + maxJobSlots.toString +
                        ") for job context '" + contextOpt.getOrElse("ad-hoc") + "'"
                      ctx.complete(503, Map(StatusKey -> "NO SLOTS AVAILABLE", ResultKey -> errorMsg))
                    case ContextInitError(e) => ctx.complete(500, errMap(e, "CONTEXT INIT FAILED"))
                  }.recover {
                    case e: Exception => ctx.complete(500, errMap(e, "ERROR"))
                  }
                }
              } catch {
                case e: NoSuchElementException =>
                  complete(StatusCodes.NotFound, errMap("context " + contextOpt.get + " not found"))
                case e: ConfigException =>
                  complete(StatusCodes.BadRequest, errMap("Cannot parse config: " + e.getMessage))
                case e: Exception =>
                  complete(500, errMap(e, "ERROR"))
              }
          }
        }
      }
  }

  private def badRequest(ctx: RequestContext, msg: String) =
    ctx.complete(StatusCodes.BadRequest, errMap(msg))

  private def notFound(ctx: RequestContext, msg: String) =
    ctx.complete(StatusCodes.NotFound, errMap(msg))

  private def errMap(errMsg: String) = Map(StatusKey -> "ERROR", ResultKey -> errMsg)

  private def errMap(t: Throwable, status: String) =
    Map(StatusKey -> status, ResultKey -> formatException(t))

  private def getJobDurationString(info: JobInfo): String =
    info.jobLengthMillis.map { ms => ms / 1000.0 + " secs" }.getOrElse("Job not done yet")

  def resultToMap(result: Any): Map[String, Any] = result match {
    case m: Map[_, _] => m.map { case (k, v) => (k.toString, v) }.toMap
    case s: Seq[_]    => s.zipWithIndex.map { case (item, idx) => (idx.toString, item) }.toMap
    case a: Array[_]  => a.toSeq.zipWithIndex.map { case (item, idx) => (idx.toString, item) }.toMap
    case item         => Map(ResultKey -> item)
  }

  def resultToTable(result: Any): Map[String, Any] = {
    Map(StatusKey -> "OK", ResultKey -> result)
  }

  def formatException(t: Throwable): Any =
    if (t.getCause != null) {
      Map("message" -> t.getMessage,
          "errorClass" -> t.getClass.getName,
          "cause" ->   t.getCause.getMessage,
          "causingClass" -> t.getCause.getClass.getName,
          "stack" -> t.getCause.getStackTrace.map(_.toString).toSeq)
    } else {
      Map("message" -> t.getMessage,
          "errorClass" -> t.getClass.getName,
          "stack" -> t.getStackTrace.map(_.toString).toSeq)
    }

  private def getJobManagerForContext(context: Option[String],
                                      contextConfig: Config,
                                      classPath: String): Option[ActorRef] = {
    import ContextSupervisor._
    val msg =
      if (context.isDefined) {
        GetContext(context.get)
      } else {
        GetAdHocContext(classPath, contextConfig)
      }
    val future = (supervisor ? msg)(contextTimeout.seconds)
    Await.result(future, contextTimeout.seconds) match {
      case (manager: ActorRef, resultActor: ActorRef) => Some(manager)
      case NoSuchContext                              => None
      case ContextInitError(err)                      => throw new RuntimeException(err)
    }
  }

}
