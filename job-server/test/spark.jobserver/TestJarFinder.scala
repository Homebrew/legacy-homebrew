package spark.jobserver

trait TestJarFinder {
  val testJarDir = "../job-server-tests/target/"
  val testJar = {
    val allJars = new java.io.File(testJarDir).listFiles.toSeq.filter { file =>
      val path = file.toString
      path.endsWith(".jar") && !path.endsWith("-tests.jar") && !path.endsWith("-sources.jar") &&
        !path.endsWith("-javadoc.jar") && !path.contains("scoverage")
    }
    assert(allJars.size == 1, allJars.toList.toString)
    allJars.head
  }
}