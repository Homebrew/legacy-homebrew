import sbt._
import Keys._
import sbtassembly.Plugin._
import AssemblyKeys._

object Assembly {
  lazy val settings = assemblySettings ++ Seq(
    jarName in assembly := "spark-job-server.jar",
    // uncomment below to exclude tests
    // test in assembly := {},
    excludedJars in assembly <<= (fullClasspath in assembly) map { _ filter { cp =>
      List("servlet-api", "guice-all", "junit", "uuid",
        "jetty", "jsp-api-2.0", "antlr", "avro", "slf4j-log4j", "log4j-1.2",
        "scala-actors", "spark", "commons-cli", "stax-api", "mockito").exists(cp.data.getName.startsWith(_))
    } },
    assembleArtifact in packageScala := false,   // We don't need the Scala library, Spark already includes it
    mergeStrategy in assembly := {
      case m if m.toLowerCase.endsWith("manifest.mf") => MergeStrategy.discard
      case m if m.toLowerCase.matches("meta-inf.*\\.sf$") => MergeStrategy.discard
      case "reference.conf" => MergeStrategy.concat
      case _ => MergeStrategy.first
    }
  )
}
