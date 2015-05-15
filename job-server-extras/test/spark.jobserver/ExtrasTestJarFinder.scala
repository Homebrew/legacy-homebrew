package spark.jobserver

import akka.actor.ActorSystem

trait ExtrasTestJarFinder extends TestJarFinder {
  override val testJarBaseDir = "job-server-extras"
}

abstract class ExtrasJobSpecBase(system: ActorSystem) extends JobSpecBaseBase(system) with ExtrasTestJarFinder