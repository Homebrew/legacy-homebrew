import sbt._
import Keys._
import sbtrelease._
import sbtrelease.ReleasePlugin.releaseSettings

object JobServerRelease {
  import ls.Plugin._
  import LsKeys._
  import sbtrelease.ReleasePlugin.ReleaseKeys._
  import sbtrelease.ReleaseStateTransformations._

  lazy val implicitlySettings = {
    lsSettings ++ Seq(
      homepage := Some(url("https://github.com/spark-jobserver/spark-jobserver")),
      (tags in lsync) := Seq("spark", "akka", "rest"),
      (description in lsync) := "REST job server for Apache Spark",
      (externalResolvers in lsync) := Seq("Job Server Bintray" at "http://dl.bintray.com/spark-jobserver/maven"),
      (ghUser in lsync) := Some("spark-jobserver"),
      (ghRepo in lsync) := Some("spark-jobserver"),
      (ghBranch in lsync) := Some("master")
    )
  }

  val syncWithLs = (ref: ProjectRef) => ReleaseStep(
                     check  = releaseTask(LsKeys.writeVersion in lsync in ref),
                     action = releaseTask(lsync in lsync in ref)
                   )

  lazy val ourReleaseSettings = releaseSettings ++ Seq(
    releaseProcess := Seq(
      checkSnapshotDependencies,
      runClean,
      runTest,
      inquireVersions,
      setReleaseVersion,
      commitReleaseVersion,
      tagRelease,
      publishArtifacts,
      // lsync seems broken, always returning: Error synchronizing project libraries Unexpected response status: 404
      // syncWithLs(thisProjectRef.value),
      setNextVersion,
      commitNextVersion,
      pushChanges
    )
  )
}