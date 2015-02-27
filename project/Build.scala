import sbt._
import Keys._
import sbtassembly.Plugin._
import AssemblyKeys._
import spray.revolver.RevolverPlugin._
import spray.revolver.Actions
import com.typesafe.sbt.SbtScalariform._
import scalariform.formatter.preferences._
import bintray.Plugin.bintrayPublishSettings

// There are advantages to using real Scala build files with SBT:
//  - Multi-JVM testing won't work without it, for now
//  - You get full IDE support
object JobServerBuild extends Build {
  lazy val dirSettings = Seq(
    unmanagedSourceDirectories in Compile <<= Seq(baseDirectory(_ / "src" )).join,
    unmanagedSourceDirectories in Test <<= Seq(baseDirectory(_ / "test" )).join,
    scalaSource in Compile <<= baseDirectory(_ / "src" ),
    scalaSource in Test <<= baseDirectory(_ / "test" )
  )

  import Dependencies._
  import JobServerRelease._

  lazy val akkaApp = Project(id = "akka-app", base = file("akka-app"),
    settings = commonSettings210 ++ Seq(
      description := "Common Akka application stack: metrics, tracing, logging, and more.",
      libraryDependencies ++= coreTestDeps ++ akkaDeps
    ) ++ publishSettings
  )

  lazy val jobServer = Project(id = "job-server", base = file("job-server"),
    settings = commonSettings210 ++ Assembly.settings ++ Revolver.settings ++ Seq(
      description  := "Spark as a Service: a RESTful job server for Apache Spark",
      libraryDependencies ++= sparkDeps ++ slickDeps ++ coreTestDeps,

      // Automatically package the test jar when we run tests here
      // And always do a clean before package (package depends on clean) to clear out multiple versions
      test in Test <<= (test in Test).dependsOn(packageBin in Compile in jobServerTestJar)
                                     .dependsOn(clean in Compile in jobServerTestJar),

      console in Compile <<= Defaults.consoleTask(fullClasspath in Compile, console in Compile),

      // Adds the path of extra jars to the front of the classpath
      fullClasspath in Compile <<= (fullClasspath in Compile).map { classpath =>
        extraJarPaths ++ classpath
      },
      javaOptions in Revolver.reStart += jobServerLogging,
      // Give job server a bit more PermGen since it does classloading
      javaOptions in Revolver.reStart += "-XX:MaxPermSize=256m",
      javaOptions in Revolver.reStart += "-Djava.security.krb5.realm= -Djava.security.krb5.kdc=",
      // This lets us add Spark back to the classpath without assembly barfing
      fullClasspath in Revolver.reStart := (fullClasspath in Compile).value,
      // Must run the examples and tests in separate JVMs to avoid mysterious
      // scala.reflect.internal.MissingRequirementError errors. (TODO)
      fork in Test := true
      ) ++ publishSettings
  ) dependsOn(akkaApp, jobServerApi)

  lazy val jobServerTestJar = Project(id = "job-server-tests", base = file("job-server-tests"),
    settings = commonSettings210 ++ Seq(libraryDependencies ++= sparkDeps ++ apiDeps,
                                        publishArtifact := false,
                                        description := "Test jar for Spark Job Server",
                                        exportJars := true)   // use the jar instead of target/classes
  ) dependsOn(jobServerApi)

  lazy val jobServerApi = Project(id = "job-server-api", base = file("job-server-api"),
    settings = commonSettings210 ++ publishSettings
                                    )

  // This meta-project aggregates all of the sub-projects and can be used to compile/test/style check
  // all of them with a single command.
  //
  // NOTE: if we don't define a root project, SBT does it for us, but without our settings
  lazy val root = Project(
    id = "root", base = file("."),
    settings =
      commonSettings210 ++ ourReleaseSettings ++ Seq(
      // Must run Spark tests sequentially because they compete for port 4040!
      parallelExecution in Test := false,
      publishArtifact := false,
      concurrentRestrictions := Seq(
        Tags.limit(Tags.CPU, java.lang.Runtime.getRuntime().availableProcessors()),
        // limit to 1 concurrent test task, even across sub-projects
        // Note: some components of tests seem to have the "Untagged" tag rather than "Test" tag.
        // So, we limit the sum of "Test", "Untagged" tags to 1 concurrent
        Tags.limitSum(1, Tags.Test, Tags.Untagged))
  )) aggregate(jobServer, jobServerApi, jobServerTestJar, akkaApp)

  // To add an extra jar to the classpath when doing "re-start" for quick development, set the
  // env var EXTRA_JAR to the absolute full path to the jar
  lazy val extraJarPaths = Option(System.getenv("EXTRA_JAR"))
                             .map(jarpath => Seq(Attributed.blank(file(jarpath))))
                             .getOrElse(Nil)

  // Create a default Scala style task to run with compiles
  lazy val runScalaStyle = taskKey[Unit]("testScalaStyle")

  lazy val commonSettings210 = Defaults.defaultSettings ++ dirSettings ++ implicitlySettings ++ Seq(
    organization := "spark.jobserver",
    crossPaths   := false,
    scalaVersion := "2.10.4",
    scalaBinaryVersion := "2.10",
    publishTo    := Some(Resolver.file("Unused repo", file("target/unusedrepo"))),

    // scalastyleFailOnError := true,
    runScalaStyle := {
      org.scalastyle.sbt.ScalastylePlugin.scalastyle.in(Compile).toTask("").value
    },
    (compile in Compile) <<= (compile in Compile) dependsOn runScalaStyle,

    // In Scala 2.10, certain language features are disabled by default, such as implicit conversions.
    // Need to pass in language options or import scala.language.* to enable them.
    // See SIP-18 (https://docs.google.com/document/d/1nlkvpoIRkx7at1qJEZafJwthZ3GeIklTFhqmXMvTX9Q/edit)
    scalacOptions := Seq("-deprecation", "-feature",
                         "-language:implicitConversions", "-language:postfixOps"),
    resolvers    ++= Dependencies.repos,
    libraryDependencies ++= apiDeps,
    parallelExecution in Test := false,
    // We need to exclude jms/jmxtools/etc because it causes undecipherable SBT errors  :(
    ivyXML :=
      <dependencies>
        <exclude module="jms"/>
        <exclude module="jmxtools"/>
        <exclude module="jmxri"/>
      </dependencies>
  ) ++ scalariformPrefs ++ scoverageSettings

  lazy val scoverageSettings = {
    import ScoverageSbtPlugin._
    instrumentSettings ++ Seq(
      // Semicolon-separated list of regexs matching classes to exclude
      ScoverageKeys.excludedPackages in scoverage := ".+Benchmark.*"
    )
  }

  lazy val publishSettings = bintrayPublishSettings ++ Seq(
    licenses += ("Apache-2.0", url("http://choosealicense.com/licenses/apache/")),
    bintray.Keys.bintrayOrganization in bintray.Keys.bintray := Some("spark-jobserver")
  )

  // change to scalariformSettings for auto format on compile; defaultScalariformSettings to disable
  // See https://github.com/mdr/scalariform for formatting options
  lazy val scalariformPrefs = defaultScalariformSettings ++ Seq(
    ScalariformKeys.preferences := FormattingPreferences()
      .setPreference(AlignParameters, true)
      .setPreference(AlignSingleLineCaseStatements, true)
      .setPreference(DoubleIndentClassDeclaration, true)
      .setPreference(PreserveDanglingCloseParenthesis, false)
  )

  // This is here so we can easily switch back to Logback when Spark fixes its log4j dependency.
  lazy val jobServerLogbackLogging = "-Dlogback.configurationFile=config/logback-local.xml"
  lazy val jobServerLogging = "-Dlog4j.configuration=config/log4j-local.properties"
}
