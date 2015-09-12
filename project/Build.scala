import sbt._
import Keys._
import sbtassembly.Plugin._
import spray.revolver.RevolverPlugin._
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
    settings = commonSettings ++ Seq(
      description := "Common Akka application stack: metrics, tracing, logging, and more.",
      libraryDependencies ++= coreTestDeps ++ akkaDeps
    ) ++ publishSettings
  )

  lazy val jobServer = Project(id = "job-server", base = file("job-server"),
    settings = commonSettings ++ revolverSettings ++ Assembly.settings ++ Seq(
      description  := "Spark as a Service: a RESTful job server for Apache Spark",
      libraryDependencies ++= sparkDeps ++ slickDeps ++ securityDeps ++ coreTestDeps,

      // Automatically package the test jar when we run tests here
      // And always do a clean before package (package depends on clean) to clear out multiple versions
      test in Test <<= (test in Test).dependsOn(packageBin in Compile in jobServerTestJar)
                                     .dependsOn(clean in Compile in jobServerTestJar),

      console in Compile <<= Defaults.consoleTask(fullClasspath in Compile, console in Compile),

      // Adds the path of extra jars to the front of the classpath
      fullClasspath in Compile <<= (fullClasspath in Compile).map { classpath =>
        extraJarPaths ++ classpath
      },
      // Must run the examples and tests in separate JVMs to avoid mysterious
      // scala.reflect.internal.MissingRequirementError errors. (TODO)
      // TODO: Remove this once we upgrade to Spark 1.4 ... see resolution of SPARK-5281.
      // Also: note that fork won't work when VPN is on or other funny networking
      fork in Test := true
      ) ++ publishSettings
  ) dependsOn(akkaApp, jobServerApi)

  lazy val jobServerTestJar = Project(id = "job-server-tests", base = file("job-server-tests"),
                                      settings = commonSettings ++ jobServerTestJarSettings
                                     ) dependsOn(jobServerApi)

  lazy val jobServerApi = Project(id = "job-server-api",
                                  base = file("job-server-api"),
                                  settings = commonSettings ++ publishSettings)

  lazy val jobServerExtras = Project(id = "job-server-extras",
                                     base = file("job-server-extras"),
                                     settings = commonSettings ++ jobServerExtrasSettings
                                    ) dependsOn(jobServerApi,
                                                jobServer % "compile->compile; test->test")

  // This meta-project aggregates all of the sub-projects and can be used to compile/test/style check
  // all of them with a single command.
  //
  // NOTE: if we don't define a root project, SBT does it for us, but without our settings
  lazy val root = Project(id = "root", base = file("."),
                    settings = commonSettings ++ ourReleaseSettings ++ rootSettings ++ dockerSettings
                  ).aggregate(jobServer, jobServerApi, jobServerTestJar, akkaApp, jobServerExtras).
                   dependsOn(jobServer, jobServerExtras)

  lazy val jobServerExtrasSettings = revolverSettings ++ Assembly.settings ++ publishSettings ++ Seq(
    libraryDependencies ++= sparkExtraDeps,
    // Extras packages up its own jar for testing itself
    test in Test <<= (test in Test).dependsOn(packageBin in Compile)
                                   .dependsOn(clean in Compile),
    fork in Test := true,
    // Temporarily disable test for assembly builds so folks can package and get started.  Some tests
    // are flaky in extras esp involving paths.
    test in AssemblyKeys.assembly := {},
    exportJars := true
  )

  lazy val jobServerTestJarSettings = Seq(
    libraryDependencies ++= sparkDeps ++ apiDeps,
    publishArtifact := false,
    description := "Test jar for Spark Job Server",
    exportJars := true        // use the jar instead of target/classes
  )

  import sbtdocker.DockerKeys._

  lazy val dockerSettings = Seq(
    // Make the docker task depend on the assembly task, which generates a fat JAR file
    docker <<= (docker dependsOn (AssemblyKeys.assembly in jobServerExtras)),
    dockerfile in docker := {
      val artifact = (AssemblyKeys.outputPath in AssemblyKeys.assembly in jobServerExtras).value
      val artifactTargetPath = s"/app/${artifact.name}"
      new sbtdocker.mutable.Dockerfile {
        from("ottoops/mesos-java7")
        // Dockerfile best practices: https://docs.docker.com/articles/dockerfile_best-practices/
        expose(8090)
        expose(9999)    // for JMX
        copy(artifact, artifactTargetPath)
        copy(baseDirectory(_ / "bin" / "server_start.sh").value, file("app/server_start.sh"))
        copy(baseDirectory(_ / "bin" / "server_stop.sh").value, file("app/server_stop.sh"))
        copy(baseDirectory(_ / "config" / "log4j-stdout.properties").value, file("app/log4j-server.properties"))
        copy(baseDirectory(_ / "config" / "docker.conf").value, file("app/docker.conf"))
        copy(baseDirectory(_ / "config" / "docker.sh").value, file("app/settings.sh"))
        // Including envs in Dockerfile makes it easy to override from docker command
        env("JOBSERVER_MEMORY", "1G")
        env("SPARK_HOME", "/spark")
        env("SPARK_BUILD", s"spark-${sparkVersion}-bin-hadoop2.4")
        // Use a volume to persist database between container invocations
        run("mkdir", "-p", "/database")
        runRaw("""wget http://d3kbcqa49mib13.cloudfront.net/$SPARK_BUILD.tgz && \
                  tar -xvf $SPARK_BUILD.tgz && \
                  mv $SPARK_BUILD /spark && \
                  rm $SPARK_BUILD.tgz
               """)
        volume("/database")
        entryPoint("app/server_start.sh")
      }
    },
    imageNames in docker := Seq(
      sbtdocker.ImageName(namespace = Some("velvia"),
                          repository = "spark-jobserver",
                          tag = Some(version.value))
    )
  )

  lazy val rootSettings = Seq(
    // Must run Spark tests sequentially because they compete for port 4040!
    parallelExecution in Test := false,
    publishArtifact := false,
    concurrentRestrictions := Seq(
      Tags.limit(Tags.CPU, java.lang.Runtime.getRuntime().availableProcessors()),
      // limit to 1 concurrent test task, even across sub-projects
      // Note: some components of tests seem to have the "Untagged" tag rather than "Test" tag.
      // So, we limit the sum of "Test", "Untagged" tags to 1 concurrent
      Tags.limitSum(1, Tags.Test, Tags.Untagged))
  )

  lazy val revolverSettings = Revolver.settings ++ Seq(
    javaOptions in Revolver.reStart += jobServerLogging,
    // Give job server a bit more PermGen since it does classloading
    javaOptions in Revolver.reStart += "-XX:MaxPermSize=256m",
    javaOptions in Revolver.reStart += "-Djava.security.krb5.realm= -Djava.security.krb5.kdc=",
    // This lets us add Spark back to the classpath without assembly barfing
    fullClasspath in Revolver.reStart := (fullClasspath in Compile).value,
    mainClass in Revolver.reStart := Some("spark.jobserver.JobServer")
  )

  // To add an extra jar to the classpath when doing "re-start" for quick development, set the
  // env var EXTRA_JAR to the absolute full path to the jar
  lazy val extraJarPaths = Option(System.getenv("EXTRA_JAR"))
                             .map(jarpath => Seq(Attributed.blank(file(jarpath))))
                             .getOrElse(Nil)

  // Create a default Scala style task to run with compiles
  lazy val runScalaStyle = taskKey[Unit]("testScalaStyle")

  lazy val commonSettings = Defaults.defaultSettings ++ dirSettings ++ implicitlySettings ++ Seq(
    organization := "spark.jobserver",
    crossPaths   := true,
    crossScalaVersions := Seq("2.10.4","2.11.6"),
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
    import scoverage.ScoverageSbtPlugin
    // Semicolon-separated list of regexs matching classes to exclude
    ScoverageSbtPlugin.ScoverageKeys.coverageExcludedPackages := ".+Benchmark.*"
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
