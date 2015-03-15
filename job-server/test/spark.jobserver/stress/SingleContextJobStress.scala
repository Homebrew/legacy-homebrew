package spark.jobserver.stress

import akka.actor.{ActorSystem, Props}
import akka.pattern.ask
import akka.util.Timeout
import com.typesafe.config.ConfigFactory
import org.joda.time.DateTime
import scala.concurrent.Await
import spark.jobserver._
import spark.jobserver.io.JobFileDAO

/**
 * A stress test for launching many jobs within a job context
 * Launch using sbt> test:run
 * Watch with visualvm to see memory usage
 *
 * TODO(velvia): Turn this into an actual test.  For now it's an app, requires manual testing.
 */
object SingleContextJobStress extends App with TestJarFinder {

  import CommonMessages.JobResult
  import JobManagerActor._
  import scala.collection.JavaConverters._
  import scala.concurrent.duration._
  val jobDaoPrefix = "target/scala-" + version + "/jobserver/"
  val config = ConfigFactory.parseString("""
    num-cpu-cores = 4           # Number of cores to allocate.  Required.
    memory-per-node = 512m      # Executor memory per node, -Xmx style eg 512m, 1G, etc.
    """)

  val system = ActorSystem("test", config)
  // Stuff needed for futures and Await
  implicit val ec = system
  implicit val ShortTimeout = Timeout(3 seconds)

  val jobDaoDir = jobDaoPrefix + DateTime.now.toString()
  val jobDaoConfig = ConfigFactory.parseMap(Map("spark.jobserver.filedao.rootdir" -> jobDaoDir).asJava)
  val dao = new JobFileDAO(jobDaoConfig)

  val jobManager = system.actorOf(Props(classOf[JobManagerActor], dao, "c1", "local[4]", config, false))

  private def uploadJar(jarFilePath: String, appName: String) {
    val bytes = scala.io.Source.fromFile(jarFilePath, "ISO-8859-1").map(_.toByte).toArray
    dao.saveJar(appName, DateTime.now, bytes)
  }

  private val demoJarPath = testJar.getAbsolutePath
  private val demoJarClass = "spark.jobserver.WordCountExample"
  private val emptyConfig = ConfigFactory.parseString("")

  // Create the context
  val res1 = Await.result(jobManager ? Initialize, 3 seconds)
  assert(res1.getClass == classOf[Initialized])

  uploadJar(demoJarPath, "demo1")

  // Now keep running this darn test ....
  var numJobs = 0
  val startTime = System.currentTimeMillis()

  while (true) {
    val f = jobManager ? StartJob("demo1", demoJarClass, emptyConfig, Set(classOf[JobResult]))
    Await.result(f, 3 seconds) match {
      case JobResult(info, Some(m)) =>
        numJobs += 1
        if (numJobs % 100 == 0) {
          val elapsed = System.currentTimeMillis() - startTime
          println("%d jobs finished in %f seconds".format(numJobs, elapsed / 1000.0))
        }
      case x =>
        println("Some error occurred: " + x)
        sys.exit(1)
    }
    // Thread sleep 1000
  }
}
