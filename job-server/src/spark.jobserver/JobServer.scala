package spark.jobserver

import akka.actor.ActorSystem
import akka.actor.Props
import com.typesafe.config.ConfigFactory
import java.io.File
import spark.jobserver.io.JobDAO
import org.slf4j.LoggerFactory

/**
 * The Spark Job Server is a web service that allows users to submit and run Spark jobs, check status,
 * and view results.
 * It may offer other goodies in the future.
 * It only takes in one optional command line arg, a config file to override the default (and you can still
 * use -Dsetting=value to override)
 * -- Configuration --
 * {{{
 *   spark {
 *     master = "local"
 *     jobserver {
 *       port = 8090
 *     }
 *   }
 * }}}
 */
object JobServer extends App {
  val logger = LoggerFactory.getLogger(getClass)
  val defaultConfig = ConfigFactory.load()
  val config = if (args.length > 0) {
    val configFile = new File(args(0))
    if (!configFile.exists()) {
      println("Could not find configuration file " + configFile)
      sys.exit(1)
    }
    ConfigFactory.parseFile(configFile).withFallback(defaultConfig)
  } else {
    defaultConfig
  }
  logger.info("Starting JobServer with config {}", config.getConfig("spark").root.render())
  val port = config.getInt("spark.jobserver.port")

  // TODO: Hardcode for now to get going. Make it configurable later.
  val clazz = Class.forName(config.getString("spark.jobserver.jobdao"))
  val ctor = clazz.getDeclaredConstructor(Class.forName("com.typesafe.config.Config"))
  val jobDAO = ctor.newInstance(config).asInstanceOf[JobDAO]

  val system = ActorSystem("JobServer", config)
  val jarManager = system.actorOf(Props(classOf[JarManager], jobDAO), "jar-manager")
  val supervisor = system.actorOf(Props(classOf[LocalContextSupervisorActor], jobDAO), "context-supervisor")
  val jobInfo = system.actorOf(Props(classOf[JobInfoActor], jobDAO, supervisor), "job-info")
  val jobConfigActor = system.actorOf(Props(classOf[JobConfigActor], jobDAO), "job-config-actor")
  // Create initial contexts
  supervisor ! ContextSupervisor.AddContextsFromConfig
  new WebApi(system, config, port, jarManager, supervisor, jobInfo, jobConfigActor).start()
}
