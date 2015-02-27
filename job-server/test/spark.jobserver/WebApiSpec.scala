package spark.jobserver

import akka.actor.{Actor, Props}
import com.typesafe.config.ConfigFactory
import spark.jobserver.io.{JobInfo, JarInfo}
import org.joda.time.DateTime
import org.scalatest.{Matchers, FunSpec, BeforeAndAfterAll}
import spray.http.StatusCodes._
import spray.routing.HttpService
import spray.testkit.ScalatestRouteTest


// Tests web response codes and formatting
// Does NOT test underlying Supervisor / JarManager functionality
// HttpService trait is needed for the sealRoute() which wraps exception handling
class WebApiSpec extends FunSpec with Matchers with BeforeAndAfterAll
with ScalatestRouteTest with HttpService {
  import scala.collection.JavaConverters._
  import spray.httpx.SprayJsonSupport._
  import spray.json.DefaultJsonProtocol._
  import ooyala.common.akka.web.JsonUtils._

  def actorRefFactory = system

  val bindConfKey = "spark.jobserver.bind-address"
  val bindConfVal = "127.0.0.1"
  val masterConfKey = "spark.master"
  val masterConfVal = "spark://localhost:7077"
  val config = ConfigFactory.parseString(s"""
    spark {
      master = "${masterConfVal}"
      jobserver.bind-address = "${bindConfVal}"
    }
                                 """)

  val dummyPort = 9999

  // See http://doc.akka.io/docs/akka/2.2.4/scala/actors.html#Deprecated_Variants;
  // for actors declared as inner classes we need to pass this as first arg
  val dummyActor = system.actorOf(Props(classOf[DummyActor], this))
  val statusActor = system.actorOf(Props(classOf[JobStatusActor], new InMemoryDAO))

  val api = new WebApi(system, config, dummyPort, dummyActor, dummyActor, dummyActor)
  val routes = api.myRoutes

  val dt = DateTime.parse("2013-05-29T00Z")
  val baseJobInfo = JobInfo("foo-1", "context", JarInfo("demo", dt), "com.abc.meme", dt, None, None)
  val StatusKey = "status"
  val ResultKey = "result"

  class DummyActor extends Actor {

    import CommonMessages._
    import ContextSupervisor._
    import JobInfoActor._
    import JobManagerActor._

    def receive = {
      case GetJobResult("_mapseq") =>
        val map = Map("first" -> Seq(1, 2, Seq("a", "b")))
        sender ! JobResult("_seqseq", map)
      case GetJobResult("_mapmap") =>
        val map = Map("second" -> Map("K" -> Map("one" -> 1)))
        sender ! JobResult("_mapmap", map)
      case GetJobResult("_seq") =>
        sender ! JobResult("_seq", Seq(1, 2, Map("3" -> "three")))
      case GetJobResult("_num") =>
        sender ! JobResult("_num", 5000)
      case GetJobResult("_unk") => sender ! JobResult("_case", Seq(1, math.BigInt(101)))
      case GetJobResult(id) => sender ! JobResult(id, id + "!!!")
      case GetJobStatuses(limitOpt) =>
        sender ! Seq(baseJobInfo,
                     baseJobInfo.copy(endTime = Some(dt.plusMinutes(5))))

      case ListJars => sender ! Map("demo1" -> dt, "demo2" -> dt.plusHours(1))
      // Ok these really belong to a JarManager but what the heck, type unsafety!!
      case StoreJar("badjar", _) => sender ! InvalidJar
      case StoreJar(_, _)        => sender ! JarStored

      case ListContexts =>  sender ! Seq("context1", "context2")
      case StopContext("none") => sender ! NoSuchContext
      case StopContext(_)      => sender ! ContextStopped
      case AddContext("one", _) => sender ! ContextAlreadyExists
      case AddContext(_, _)     => sender ! ContextInitialized

      case GetContext("no-context") => sender ! NoSuchContext
      case GetContext(_)            => sender ! (self, self)

      case GetAdHocContext(_, _) => sender ! (self, self)

      // These routes are part of JobManagerActor
      case StartJob("no-app", _, _, _)   =>  sender ! NoSuchApplication
      case StartJob(_, "no-class", _, _) =>  sender ! NoSuchClass
      case StartJob("wrong-type", _, _, _) => sender ! WrongJobType
      case StartJob("err", _, config, _) =>  sender ! JobErroredOut("foo", dt,
                                                        new RuntimeException("oops",
                                                          new IllegalArgumentException("foo")))
      case StartJob(_, _, config, events)     =>
        statusActor ! Subscribe("foo", sender, events)
        statusActor ! JobStatusActor.JobInit(JobInfo("foo", "context", null, "", dt, None, None))
        statusActor ! JobStarted("foo", "context1", dt)
        val map = config.entrySet().asScala.map { entry => (entry.getKey -> entry.getValue.unwrapped) }.toMap
        if (events.contains(classOf[JobResult])) sender ! JobResult("foo", map)
        statusActor ! Unsubscribe("foo", sender)

      case GetJobConfig("badjobid") => sender ! NoSuchJobId
      case GetJobConfig(_)          => sender ! config
    }
  }

  describe("jars routes") {
    it("should list all jars") {
      Get("/jars") ~> sealRoute(routes) ~> check {
        status should be (OK)
        responseAs[Map[String, String]] should be (Map("demo1" -> "2013-05-29T00:00:00.000Z",
                                                     "demo2" -> "2013-05-29T01:00:00.000Z"))
      }
    }

    it("should respond with OK if jar uploaded successfully") {
      Post("/jars/foobar", Array[Byte](0, 1, 2)) ~> sealRoute(routes) ~> check {
        status should be (OK)
      }
    }

    it("should respond with bad request if jar formatted incorrectly") {
      Post("/jars/badjar", Array[Byte](0, 1, 2)) ~> sealRoute(routes) ~> check {
        status should be (BadRequest)
      }
    }
  }

  describe("list jobs") {
    it("should list jobs correctly") {
      Get("/jobs") ~> sealRoute(routes) ~> check {
        status should be (OK)
        responseAs[Seq[Map[String, String]]] should be (Seq(
          Map("jobId" -> "foo-1",
              "startTime" -> "2013-05-29T00:00:00.000Z",
              "classPath" -> "com.abc.meme",
              "context"  -> "context",
              "duration" -> "Job not done yet",
              StatusKey -> "RUNNING"),
          Map("jobId" -> "foo-1",
              "startTime" -> "2013-05-29T00:00:00.000Z",
              "classPath" -> "com.abc.meme",
              "context"  -> "context",
              "duration" -> "300.0 secs",
              StatusKey -> "FINISHED")
        ))
      }
    }
  }

  describe("/jobs routes") {
    it("should respond with bad request if jobConfig cannot be parsed") {
      Post("/jobs?appName=foo&classPath=com.abc.meme", "Not parseable jobConfig!!") ~>
          sealRoute(routes) ~> check {
        status should be (BadRequest)
        val result = responseAs[Map[String, String]]
        result(StatusKey) should equal("ERROR")
        result(ResultKey) should startWith ("Cannot parse")
      }
      Post("/jobs?appName=foo&classPath=com.abc.meme&sync=true", "Not parseable jobConfig!!") ~>
          sealRoute(routes) ~> check {
        status should be (BadRequest)
        val result = responseAs[Map[String, String]]
        result(StatusKey) should equal("ERROR")
        result(ResultKey) should startWith ("Cannot parse")
      }
    }

    it("should merge user passed jobConfig with default jobConfig") {
      val config2 = "foo.baz = booboo"
      Post("/jobs?appName=foo&classPath=com.abc.meme&context=one&sync=true", config2) ~>
          sealRoute(routes) ~> check {
        status should be (OK)
        responseAs[Map[String, Any]] should be (Map(
          StatusKey -> "OK",
          ResultKey -> Map(masterConfKey->masterConfVal, bindConfKey -> bindConfVal, "foo.baz" -> "booboo")
        ))
      }
    }

    it("async route should return 202 if job starts successfully") {
      Post("/jobs?appName=foo&classPath=com.abc.meme&context=one", "") ~> sealRoute(routes) ~> check {
        status should be (Accepted)
        responseAs[Map[String, Any]] should be (Map(
          StatusKey -> "STARTED",
          ResultKey -> Map("jobId" -> "foo", "context" -> "context1")
        ))
      }
    }

    it("adhoc job of sync route should return 200 and result") {
      val config2 = "foo.baz = booboo"
      Post("/jobs?appName=foo&classPath=com.abc.meme&sync=true", config2) ~>
        sealRoute(routes) ~> check {
        status should be (OK)
        responseAs[Map[String, Any]] should be (Map(
          StatusKey -> "OK",
          ResultKey -> Map(masterConfKey->masterConfVal, bindConfKey -> bindConfVal, "foo.baz" -> "booboo")
        ))
      }
    }

    it("should be able to take a timeout param") {
      val config2 = "foo.baz = booboo"
      Post("/jobs?appName=foo&classPath=com.abc.meme&sync=true&timeout=5", config2) ~>
        sealRoute(routes) ~> check {
        status should be (OK)
        responseAs[Map[String, Any]] should be (Map(
          StatusKey -> "OK",
          ResultKey -> Map(masterConfKey->masterConfVal, bindConfKey -> bindConfVal, "foo.baz" -> "booboo")
        ))
      }
    }

    it("adhoc job started successfully of async route should return 202") {
      Post("/jobs?appName=foo&classPath=com.abc.meme", "") ~> sealRoute(routes) ~> check {
        status should be (Accepted)
        responseAs[Map[String, Any]] should be (Map(
          StatusKey -> "STARTED",
          ResultKey -> Map("jobId" -> "foo", "context" -> "context1")
        ))
      }
    }

    it("should be able to query job result from /jobs/<id> route") {
      Get("/jobs/foobar") ~> sealRoute(routes) ~> check {
        status should be (OK)
        responseAs[Map[String, String]] should be (Map(
          StatusKey -> "OK",
          ResultKey -> "foobar!!!"
        ))
      }
    }

    it("should be able to query job config from /jobs/<id>/config route") {
      Get("/jobs/foobar/config") ~> sealRoute(routes) ~> check {
        status should be (OK)
        ConfigFactory.parseString(responseAs[String]) should be (config)
      }
    }

    it("should respond with 404 Not Found from /jobs/<id>/config route if jobId does not exist") {
      Get("/jobs/badjobid/config") ~> sealRoute(routes) ~> check {
        status should be (NotFound)
      }
    }

    it("should respond with 404 Not Found if context does not exist") {
      Post("/jobs?appName=foo&classPath=com.abc.meme&context=no-context", " ") ~> sealRoute(routes) ~> check {
        status should be (NotFound)
        val resultMap = responseAs[Map[String, String]]
        resultMap(StatusKey) should be ("ERROR")
      }
    }

    it("should respond with 404 Not Found if app or class not found") {
      Post("/jobs?appName=no-app&classPath=com.abc.meme&context=one", " ") ~> sealRoute(routes) ~> check {
        status should be (NotFound)
        val resultMap = responseAs[Map[String, String]]
        resultMap(StatusKey) should be ("ERROR")
      }

      Post("/jobs?appName=foobar&classPath=no-class&context=one", " ") ~> sealRoute(routes) ~> check {
        status should be (NotFound)
      }
    }

    it("should respond with 400 if job is of the wrong type") {
      Post("/jobs?appName=wrong-type&classPath=com.abc.meme", " ") ~> sealRoute(routes) ~> check {
        status should be (BadRequest)
        val resultMap = responseAs[Map[String, String]]
        resultMap(StatusKey) should be ("ERROR")
      }
    }

    it("sync route should return Ok with ERROR in JSON response if job failed") {
      Post("/jobs?appName=err&classPath=com.abc.meme&context=one&sync=true", " ") ~>
          sealRoute(routes) ~> check {
        status should be (OK)
        val result = responseAs[Map[String, Any]]
        result(StatusKey) should equal("ERROR")
        result.keys should equal (Set(StatusKey, ResultKey))
        val exceptionMap = result(ResultKey).asInstanceOf[Map[String, Any]]
        exceptionMap should contain key ("cause")
        exceptionMap should contain key ("causingClass")
        exceptionMap("cause") should equal ("foo")
        exceptionMap("causingClass").asInstanceOf[String] should include ("IllegalArgumentException")
      }
    }
  }

  describe("serializing complex data types") {
    it("should be able to serialize nested Seq's and Map's within Map's to JSON") {
      Get("/jobs/_mapseq") ~> sealRoute(routes) ~> check {
        status should be (OK)
        responseAs[Map[String, Any]] should be (Map(
          StatusKey -> "OK",
          ResultKey -> Map("first" -> Seq(1, 2, Seq("a", "b")))
      ))
      }

      Get("/jobs/_mapmap") ~> sealRoute(routes) ~> check {
        status should be (OK)
        responseAs[Map[String, Any]] should be (Map(
          StatusKey -> "OK",
          ResultKey -> Map("second" -> Map("K" -> Map("one" -> 1)))
        ))
      }
    }

    it("should be able to serialize Seq's with different types to JSON") {
      Get("/jobs/_seq") ~> sealRoute(routes) ~> check {
        status should be (OK)
        responseAs[Map[String, Any]] should be (
          Map( StatusKey -> "OK",
            ResultKey -> Seq(1, 2, Map("3" -> "three"))
          )
        )
      }
    }

    it("should be able to serialize base types (eg float, numbers) to JSON") {
      Get("/jobs/_num") ~> sealRoute(routes) ~> check {
        status should be (OK)
        responseAs[Map[String, Any]] should be (
          Map(StatusKey -> "OK", ResultKey -> 5000)
        )
      }
    }

    it("should convert non-understood types to string") {
      Get("/jobs/_unk") ~> sealRoute(routes) ~> check {
        status should be (OK)
        responseAs[Map[String, Any]] should be (
          Map(StatusKey -> "OK", ResultKey -> Seq(1,  "101"))
        )
      }
    }
  }

  describe("context routes") {
    it("should list all contexts") {
      // responseAs[] uses spray-json to convert JSON results back to types for easier checking
      Get("/contexts") ~> sealRoute(routes) ~> check {
        status should be (OK)
        responseAs[Seq[String]] should be (Seq("context1", "context2"))
      }
    }

    it("should respond with 404 Not Found if stopping unknown context") {
      Delete("/contexts/none", "") ~> sealRoute(routes) ~> check {
        status should be (NotFound)
      }
    }

    it("should return OK if stopping known context") {
      Delete("/contexts/one", "") ~> sealRoute(routes) ~> check {
        status should be (OK)
      }
    }

    it("should respond with bad request if starting an already started context") {
      Post("/contexts/one") ~> sealRoute(routes) ~> check {
        status should be (BadRequest)
        val result = responseAs[Map[String, String]]
        result(StatusKey) should equal("ERROR")
      }
    }

    it("should return OK if starting a new context") {
      Post("/contexts/meme?num-cpu-cores=3") ~> sealRoute(routes) ~> check {
        status should be (OK)
      }
      Post("/contexts/meme?num-cpu-cores=3&coarse-mesos-mode=true") ~> sealRoute(routes) ~> check {
        status should be (OK)
      }
    }
  }
}

