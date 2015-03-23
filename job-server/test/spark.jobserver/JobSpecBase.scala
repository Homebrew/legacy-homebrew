package spark.jobserver

import akka.actor.{ActorSystem, ActorRef}
import akka.testkit.ImplicitSender
import akka.testkit.TestKit
import com.typesafe.config.ConfigFactory
import org.joda.time.DateTime
import org.scalatest.{BeforeAndAfter, BeforeAndAfterAll, FunSpecLike, Matchers}
import spark.jobserver.context.DefaultSparkContextFactory
import spark.jobserver.io.JobDAO

/**
 * Provides a base Config for tests.  Override the vals to configure.  Mix into an object.
 */
trait JobSpecConfig {
  import collection.JavaConverters._

  val JobResultCacheSize = 30
  val NumCpuCores = Runtime.getRuntime.availableProcessors()  // number of cores to allocate. Required.
  val MemoryPerNode = "512m"  // Executor memory per node, -Xmx style eg 512m, 1G, etc.
  val MaxJobsPerContext = 2
  def contextFactory = classOf[DefaultSparkContextFactory].getName
  lazy val config = {
    val ConfigMap = Map(
      "spark.jobserver.job-result-cache-size" -> JobResultCacheSize,
      "num-cpu-cores" -> NumCpuCores,
      "memory-per-node" -> MemoryPerNode,
      "spark.jobserver.max-jobs-per-context" -> MaxJobsPerContext,
      "akka.log-dead-letters" -> 0,
      "spark.master" -> "local[4]",
      "context-factory" -> contextFactory
    )
    ConfigFactory.parseMap(ConfigMap.asJava)
  }

  def getNewSystem = ActorSystem("test", config)
}

abstract class JobSpecBase(system: ActorSystem) extends TestKit(system) with ImplicitSender
with FunSpecLike with Matchers with BeforeAndAfter with BeforeAndAfterAll with TestJarFinder {
  var dao: JobDAO = _
  var manager: ActorRef = _

  after {
    ooyala.common.akka.AkkaTestUtils.shutdownAndWait(manager)
  }

  override def afterAll() {
    ooyala.common.akka.AkkaTestUtils.shutdownAndWait(system)
  }

  protected def uploadJar(dao: JobDAO, jarFilePath: String, appName: String) {
    val bytes = scala.io.Source.fromFile(jarFilePath, "ISO-8859-1").map(_.toByte).toArray
    dao.saveJar(appName, DateTime.now, bytes)
  }

  protected def uploadTestJar(appName: String = "demo") { uploadJar(dao, testJar.getAbsolutePath, appName) }

  import CommonMessages._

  val errorEvents: Set[Class[_]] = Set(classOf[JobErroredOut], classOf[JobValidationFailed],
    classOf[NoJobSlotsAvailable])
  val asyncEvents = Set(classOf[JobStarted])
  val syncEvents = Set(classOf[JobResult])
  val allEvents = errorEvents ++ asyncEvents ++ syncEvents ++ Set(classOf[JobFinished])
}