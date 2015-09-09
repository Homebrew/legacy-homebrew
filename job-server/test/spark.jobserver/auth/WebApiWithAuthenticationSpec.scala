package spark.jobserver.auth

import akka.actor.{ Actor, Props }
import com.typesafe.config.{ ConfigFactory, ConfigValueFactory }
import spark.jobserver._
import spark.jobserver.io.{ JobInfo, JarInfo }
import org.joda.time.DateTime
import org.scalatest.{ Matchers, FunSpec, BeforeAndAfterAll }
import spray.http.StatusCodes._
import spray.http.HttpHeaders.Authorization
import spray.http.BasicHttpCredentials
import spray.routing.{ HttpService, Route }
import spray.testkit.ScalatestRouteTest
import org.apache.shiro.config.IniSecurityManagerFactory
import org.apache.shiro.mgt.DefaultSecurityManager
import org.apache.shiro.mgt.SecurityManager
import org.apache.shiro.realm.Realm
import org.apache.shiro.SecurityUtils
import org.apache.shiro.config.Ini

// Tests authorization only, actual responses are tested elsewhere
// Does NOT test underlying Supervisor / JarManager functionality
// HttpService trait is needed for the sealRoute() which wraps exception handling
class WebApiWithAuthenticationSpec extends FunSpec with Matchers with BeforeAndAfterAll
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
    shiro {
      authentication = on
    }
                                 """)

  val dummyPort = 9999

  // See http://doc.akka.io/docs/akka/2.2.4/scala/actors.html#Deprecated_Variants;
  // for actors declared as inner classes we need to pass this as first arg
  private val dummyActor = system.actorOf(Props(classOf[DummyActor], this))

  private def routesWithTimeout(authTimeout: String): Route = {
    val api = new WebApi(system, config.withValue("shiro.authentication-timeout", ConfigValueFactory.fromAnyRef(authTimeout)), dummyPort, dummyActor, dummyActor, dummyActor, dummyActor) {
      override def initSecurityManager() {

        val ini = {
          val tmp = new Ini()
          tmp.load(SJSAuthenticatorSpec.DummyIniConfig)
          tmp
        }
        val factory = new IniSecurityManagerFactory(ini)

        val sManager = factory.getInstance()
        SecurityUtils.setSecurityManager(sManager)
      }
    }
    api.myRoutes
  }

  private val routes = routesWithTimeout("1 s")

  // set to some valid user
  private val authorization = new Authorization(new BasicHttpCredentials("presidentskroob", "12345"))
  private val authorizationInvalidPassword = new Authorization(new BasicHttpCredentials("presidentskroob", "xxx"))
  private val authorizationUnknownUser = new Authorization(new BasicHttpCredentials("whoami", "xxx"))

  class DummyActor extends Actor {
    import CommonMessages._
    def receive = {
      case ListJars                       => sender ! Map()
      case GetJobResult(id)               => sender ! JobResult(id, id + "!!!")
      case ContextSupervisor.ListContexts => sender ! Seq("context1", "context2")
    }
  }

  describe("jars routes") {
    it("should allow user with valid authorization") {
      Get("/jars").withHeaders(authorization) ~> sealRoute(routes) ~> check {
        status should be(OK)
      }
    }

    it("should not allow user with invalid password") {
      Post("/jars/foobar", Array[Byte](0, 1, 2)).withHeaders(authorizationInvalidPassword) ~> sealRoute(routes) ~> check {
        status should be(Unauthorized)
      }
    }

    it("should not allow unknown user") {
      Get("/jars").withHeaders(authorizationUnknownUser) ~> sealRoute(routes) ~> check {
        status should be(Unauthorized)
      }
    }
  }

  describe("/jobs routes") {
    it("should allow user with valid authorization") {
      Get("/jobs/foobar").withHeaders(authorization) ~>
        sealRoute(routes) ~> check {
          status should be(OK)
        }
    }

    it("should not allow user with invalid password") {
      val config2 = "foo.baz = booboo"
      Post("/jobs?appName=foo&classPath=com.abc.meme&context=one&sync=true", config2).withHeaders(authorizationInvalidPassword) ~>
        sealRoute(routes) ~> check {
          status should be(Unauthorized)
        }
    }

    it("should not allow unknown user") {
      Delete("/jobs/job_to_kill").withHeaders(authorizationUnknownUser) ~> sealRoute(routes) ~> check {
        status should be(Unauthorized)
      }
    }
  }

  describe("context routes") {
    it("should allow user with valid authorization") {
      Get("/contexts").withHeaders(authorization) ~>
        sealRoute(routes) ~> check {
          status should be(OK)
        }
    }

    it("should not allow user with invalid password") {
      Post("/contexts/one").withHeaders(authorizationInvalidPassword) ~>
        sealRoute(routes) ~> check {
          status should be(Unauthorized)
        }
    }

    it("should not allow unknown user") {
      Delete("/contexts/xxx").withHeaders(authorizationUnknownUser) ~> sealRoute(routes) ~> check {
        status should be(Unauthorized)
      }
    }
  }

  describe("routes with timeout") {
    it("jobs should not allow user with valid authorization when timeout") {
      Get("/jobs/foobar").withHeaders(authorization) ~>
        sealRoute(routesWithTimeout("0 s")) ~> check {
          status should be(InternalServerError)
        }
    }

    it("jars should not allow user with valid authorization when timeout") {
      Get("/jars").withHeaders(authorization) ~>
        sealRoute(routesWithTimeout("0 s")) ~> check {
          status should be(InternalServerError)
        }
    }

    it("contexts should not allow user with valid authorization when timeout") {
      Get("/contexts").withHeaders(authorization) ~>
        sealRoute(routesWithTimeout("0 s")) ~> check {
          status should be(InternalServerError)
        }
    }
  }
}

