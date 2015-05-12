package spark.jobserver

import akka.actor.ActorSystem

trait ExtrasTestJarFinder extends TestJarFinder {
  override def testJarDir = "job-server-extras/target/scala-" + version + "/"
}

abstract class ExtrasJobSpecBase(system: ActorSystem) extends JobSpecBaseBase(system) with ExtrasTestJarFinder