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

  // *** TEST DATA ***
  val time: DateTime = new DateTime()
  val throwable: Throwable = new Throwable("test-error")
  // jar test data
  val jarInfo: JarInfo = genJarInfo(false, false)
  val jarBytes: Array[Byte] = Files.toByteArray(testJar)
  var jarFile: File = new File(config.getString("spark.jobserver.sqldao.rootdir"),
                               jarInfo.appName + "-" + jarInfo.uploadTime + ".jar")

  // jobInfo test data
  val jobInfoNoEndNoErr:JobInfo = genJobInfo(jarInfo, false, false, false)
  val expectedJobInfo = jobInfoNoEndNoErr
  val jobInfoSomeEndNoErr: JobInfo = genJobInfo(jarInfo, true, false, false)
  val jobInfoNoEndSomeErr: JobInfo = genJobInfo(jarInfo, false, true, false)
  val jobInfoSomeEndSomeErr: JobInfo = genJobInfo(jarInfo, true, true, false)

  // job config test data
  val jobId: String = jobInfoNoEndNoErr.jobId
  val jobConfig: Config = ConfigFactory.parseString("{marco=pollo}")
  val expectedConfig: Config = ConfigFactory.empty().withValue("marco", ConfigValueFactory.fromAnyRef("pollo"))

  // Helper functions and closures!!
  private def genJarInfoClosure = {
    var appCount: Int = 0
    var timeCount: Int = 0

    def genTestJarInfo(newAppName: Boolean, newTime: Boolean): JarInfo = {
      appCount = appCount + (if (newAppName) 1 else 0)
      timeCount = timeCount + (if (newTime) 1 else 0)

      val app = "test-appName" + appCount
      val upload = if (newTime) time.plusMinutes(timeCount) else time

      JarInfo(app, upload)
    }

    genTestJarInfo _
  }

  private def genJobInfoClosure = {
    var count: Int = 0

    def genTestJobInfo(jarInfo: JarInfo, hasEndTime: Boolean, hasError: Boolean, isNew:Boolean): JobInfo = {
      count = count + (if (isNew) 1 else 0)

      val id: String = "test-id" + count
      val contextName: String = "test-context"
      val classPath: String = "test-classpath"
      val startTime: DateTime = time

      val noEndTime: Option[DateTime] = None
      val someEndTime: Option[DateTime] = Some(time) // Any DateTime Option is fine
      val noError: Option[Throwable] = None
      val someError: Option[Throwable] = Some(throwable)

      val endTime: Option[DateTime] = if (hasEndTime) someEndTime else noEndTime
      val error: Option[Throwable] = if (hasError) someError else noError

      JobInfo(id, contextName, jarInfo, classPath, startTime, endTime, error)
    }

    genTestJobInfo _
  }

  def genJarInfo = genJarInfoClosure
  def genJobInfo = genJobInfoClosure
  //**********************************

  before {
    dao = new JobSqlDAO(config)
    jarFile.delete()
  }

  describe("save and get the jars") {
    it("should be able to save one jar and get it back") {
      // check the pre-condition
      jarFile.exists() should equal (false)

      // save
      dao.saveJar(jarInfo.appName, jarInfo.uploadTime, jarBytes)

      // read it back
      val apps = dao.getApps

      // test
      jarFile.exists() should equal (true)
      apps.keySet should equal (Set(jarInfo.appName))
      apps(jarInfo.appName) should equal (jarInfo.uploadTime)
    }

    it("should be able to retrieve the jar file") {
      // check the pre-condition
      jarFile.exists() should equal (false)

      // retrieve the jar file
      val jarFilePath: String = dao.retrieveJarFile(jarInfo.appName, jarInfo.uploadTime)

      // test
      jarFile.exists() should equal (true)
      jarFilePath should equal (jarFile.getAbsolutePath)
    }
  }

  describe("saveJobConfig() and getJobConfigs() tests") {
    it("should provide an empty map on getJobConfigs() for an empty CONFIGS table") {
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
      val jobId2: String = genJobInfo(genJarInfo(false, false), false, false, true).jobId
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

  describe("Basic saveJobInfo() and getJobInfos() tests") {
    it("should provide an empty map on getJobInfos() for an empty JOBS table") {
      (Map.empty[String, JobInfo]) should equal (dao.getJobInfos)
    }

    it("should save a new JobInfo and get the same JobInfo") {
      // save JobInfo
      dao.saveJobInfo(jobInfoNoEndNoErr)

      // get all JobInfos
      val jobs = dao.getJobInfos

      // test
      jobs.keySet should equal (Set(jobId))
      jobs(jobId) should equal (expectedJobInfo)
    }

    it("should be able to get previously saved JobInfo") {
      // jobInfo saved in prior test

      // get jobInfos
      val jobs = dao.getJobInfos

      // test
      jobs.keySet should equal (Set(jobId))
      jobs(jobId) should equal (expectedJobInfo)
    }

    it("Save another new jobInfo, bring down DB, bring up DB, should JobInfos from DB") {
      val jobInfo2 = genJobInfo(jarInfo, false, false, true)
      val jobId2 = jobInfo2.jobId
      val expectedJobInfo2 = jobInfo2
      // jobInfo previously saved

      // save new job config
      dao.saveJobInfo(jobInfo2)

      // Destroy and bring up the DB again
      dao = null
      dao = new JobSqlDAO(config)

      // Get all jobInfos
      val jobs = dao.getJobInfos

      // test
      jobs.keySet should equal (Set(jobId, jobId2))
      jobs.values.toSeq should equal (Seq(expectedJobInfo, expectedJobInfo2))
    }

    it("saving a JobInfo with the same jobId should update the JOBS table") {
      val expectedNoEndSomeErr = jobInfoNoEndSomeErr
      val expectedSomeEndNoErr = jobInfoSomeEndNoErr
      val expectedSomeEndSomeErr = jobInfoSomeEndSomeErr
      val exJobId = jobInfoNoEndNoErr.jobId

      val info = genJarInfo(true, false)
      info.uploadTime should equal (jarInfo.uploadTime)

      // Get all jobInfos
      val jobs: Map[String, JobInfo] = dao.getJobInfos

      // First Test
      jobs.size should equal (2)
      jobs(exJobId) should equal (expectedJobInfo)

      // Second Test
      // Cannot compare JobInfos directly if error is a Some(Throwable) because
      // Throwable uses referential equality
      dao.saveJobInfo(jobInfoNoEndSomeErr)
      val jobs2 = dao.getJobInfos
      jobs2.size should equal (2)
      jobs2(exJobId).endTime should equal (None)
      jobs2(exJobId).error.isDefined should equal (true)
      intercept[Throwable] { jobs2(exJobId).error.map(throw _) }
      jobs2(exJobId).error.get.getMessage should equal (throwable.getMessage)

      // Third Test
      dao.saveJobInfo(jobInfoSomeEndNoErr)
      val jobs3 = dao.getJobInfos
      jobs3.size should equal (2)
      jobs3(exJobId).error.isDefined should equal (false)
      jobs3(exJobId) should equal (expectedSomeEndNoErr)

      // Fourth Test
      // Cannot compare JobInfos directly if error is a Some(Throwable) because
      // Throwable uses referential equality
      dao.saveJobInfo(jobInfoSomeEndSomeErr)
      val jobs4 = dao.getJobInfos
      jobs4.size should equal (2)
      jobs4(exJobId).endTime should equal (expectedSomeEndSomeErr.endTime)
      jobs4(exJobId).error.isDefined should equal (true)
      intercept[Throwable] { jobs4(exJobId).error.map(throw _) }
      jobs4(exJobId).error.get.getMessage should equal (throwable.getMessage)
    }
  }
}
