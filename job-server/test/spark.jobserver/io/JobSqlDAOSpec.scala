package spark.jobserver.io

import com.typesafe.config.{Config, ConfigFactory, ConfigValueFactory}
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
  val jobId: String = "test-id"
  val jobConfig: Config = ConfigFactory.parseString("{marco=pollo}")
  val expectedConfig = ConfigFactory.empty().withValue("marco", ConfigValueFactory.fromAnyRef("pollo"))

  before {
    dao = new JobSqlDAO(config)
    jarFile.delete()
  }

  // NOTE: Take note that all saves to the DB are obviously persisted
  // test after test.
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

    it("should be able to retrieve the jar file") {
      // check the pre-condition
      jarFile.exists() should equal (false)

      // retrieve the jar file
      val jarFilePath: String = dao.retrieveJarFile(appName, uploadTime)

      // test
      jarFile.exists() should equal (true)
      jarFilePath should equal (jarFile.getAbsolutePath)
    }
  }

  describe("saveJobConfig() and getJobConfigs() tests") {
    it("should provide an empty map on getJobConfigs() for an empty database") {
      (Map.empty[String, Config]) should equal (dao.getJobConfigs)
    }

    it("should save and get the same config") {
      // save job config
      dao.saveJobConfig(jobId, jobConfig)

      // get all configs
      val configs = dao.getJobConfigs

      // test
      configs.keySet should equal (Set(jobId))
      configs(jobId) should equal (expectedConfig)
    }

    it("should be able to get previously saved config") {
      // config saved in prior test

      // get job configs
      val configs = dao.getJobConfigs

      // test
      configs.keySet should equal (Set(jobId))
      configs(jobId) should equal (expectedConfig)
    }

    it("Save a new config, bring down DB, bring up DB, should get configs from DB") {
      val jobId2: String = "test-id2"
      val jobConfig2: Config = ConfigFactory.parseString("{merry=xmas}")
      val expectedConfig2 = ConfigFactory.empty().withValue("merry", ConfigValueFactory.fromAnyRef("xmas"))

      // config previously saved

      // save new job config
      dao.saveJobConfig(jobId2, jobConfig2)

      // Destroy and bring up the DB again
      dao = null
      dao = new JobSqlDAO(config)

      // Get all configs
      val configs = dao.getJobConfigs

      // test
      configs.keySet should equal (Set(jobId, jobId2))
      configs.values.toSeq should equal (Seq(expectedConfig, expectedConfig2))
    }
  }
}
