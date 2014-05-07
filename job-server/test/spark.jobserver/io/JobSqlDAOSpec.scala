package spark.jobserver.io

import com.typesafe.config.ConfigFactory
import org.joda.time.DateTime
import org.scalatest.{BeforeAndAfter, FunSpec}
import org.scalatest.matchers.ShouldMatchers
import spark.jobserver.TestJarFinder
import com.google.common.io.Files
import java.io.File

class JobSqlDAOSpec extends TestJarFinder with FunSpec with ShouldMatchers with BeforeAndAfter {
  private val config = ConfigFactory.load("local.test.jobsqldao.conf")

  var dao: JobSqlDAO = _

  // Test data
  val appName = "test-appName"
  val uploadTime =  new DateTime()
  val jarBytes: Array[Byte] = Files.toByteArray(testJar)
  var jarFile: File = new File(config.getString("spark.jobserver.sqldao.rootdir"), appName + "-" + uploadTime + ".jar")

  before {
    dao = new JobSqlDAO(config)
    jarFile.delete()
  }

  describe("save and get the jars") {
    it("should be able to save one jar and get it back") {
      // check the pre-condition
      jarFile.exists() should equal (false)

      // save
      dao.saveJar(appName, uploadTime, jarBytes)

      // read it back
      val apps = dao.getApps

      // test
      jarFile.exists() should equal (true)
      apps.keySet should equal (Set(appName))
      apps(appName) should equal (uploadTime)
    }
  }

}
