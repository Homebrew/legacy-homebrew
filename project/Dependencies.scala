import sbt._
import Keys._

object Dependencies {
  val excludeCglib = ExclusionRule(organization = "org.sonatype.sisu.inject")
  val excludeJackson = ExclusionRule(organization = "org.codehaus.jackson")
  val excludeNetty = ExclusionRule(organization = "org.jboss.netty")
  val excludeAsm = ExclusionRule(organization = "asm")

  lazy val typeSafeConfigDeps = "com.typesafe" % "config" % "1.0.0"
  lazy val yammerDeps = "com.yammer.metrics" % "metrics-core" % "2.2.0"

  lazy val yodaDeps = Seq(
    "org.joda" % "joda-convert" % "1.2",
    "joda-time" % "joda-time" % "2.1"
  )

  lazy val akkaDeps = Seq(
    // Akka is provided because Spark already includes it, and Spark's version is shaded so it's not safe
    // to use this one
    "com.typesafe.akka" %% "akka-slf4j" % "2.2.4" % "provided",
    "io.spray" %% "spray-json" % "1.2.5",
    "io.spray" % "spray-can" % "1.2.0",
    "io.spray" % "spray-routing" % "1.2.0",
    "io.spray" % "spray-client" % "1.2.0",
    yammerDeps
  ) ++ yodaDeps

  lazy val sparkDeps = Seq(
    "org.apache.spark" %% "spark-core" % "1.0.2" % "provided" exclude("io.netty", "netty-all"),
    // Force netty version.  This avoids some Spark netty dependency problem.
    "io.netty" % "netty" % "3.6.6.Final"
  )

  lazy val slickDeps = Seq(
    "com.typesafe.slick" %% "slick" % "2.0.2-RC1",
    "com.h2database" % "h2" % "1.3.170"
  )

  lazy val logbackDeps = Seq(
    "ch.qos.logback" % "logback-classic" % "1.0.7"
  )

  lazy val coreTestDeps = Seq(
    "org.scalatest" %% "scalatest" % "1.9.1" % "test",
    "com.typesafe.akka" %% "akka-testkit" % "2.2.4" % "test",
    "io.spray" % "spray-testkit" % "1.2.0" % "test"
  )


  lazy val serverDeps = apiDeps ++ yodaDeps
  lazy val apiDeps = sparkDeps :+ typeSafeConfigDeps
  
  val repos = Seq(
    "Typesafe Repo" at "http://repo.typesafe.com/typesafe/releases/",
    "sonatype snapshots" at "https://oss.sonatype.org/content/repositories/snapshots/",
    "spray repo" at "http://repo.spray.io"
  )
}
