package spark.jobserver.util

import com.typesafe.config.{ ConfigFactory, ConfigValueFactory }
import org.apache.spark.SparkConf
import org.scalatest.{ Matchers, FunSpec }
import java.io.FileNotFoundException
import javax.net.ssl.SSLContext

class SSLContextFactorySpec extends FunSpec with Matchers {
  import collection.JavaConverters._

  val config = ConfigFactory.parseMap(Map(
    "spray.can.server.ssl-encryption" -> "on",
    "spray.can.server.keystore" -> "~/sjs.jks",
    "spray.can.server.keystorePW" -> "changeit",
    "spray.can.server.encryptionType" -> "SSL", //SSL or TLS
    "spray.can.server.keystoreType" -> "JKS",
    "spray.can.server.provider" -> "SunX509").asJava).withValue("spray.can.server.enabledProtocols", ConfigValueFactory.fromIterable(List("SSLv3", "TLSv1").asJava))

  describe("SSLContextFactory.checkRequiredParamsSet") {
    it("should throw an exception when keystore param is missing") {
      val thrown = the[RuntimeException] thrownBy SSLContextFactory.checkRequiredParamsSet(config.getConfig("spray.can.server").withoutPath("keystore"))
      thrown.getMessage should equal(SSLContextFactory.MISSING_KEYSTORE_MSG)
    }

    it("should throw an exception when keystore password param is missing") {
      val thrown = the[RuntimeException] thrownBy SSLContextFactory.checkRequiredParamsSet(config.getConfig("spray.can.server").withoutPath("keystorePW"))
      thrown.getMessage should equal(SSLContextFactory.MISSING_KEYSTORE_PASSWORD_MSG)
    }

    it("should be silent when all necessary params are set") {
      SSLContextFactory.checkRequiredParamsSet(config.getConfig("spray.can.server"))
    }
  }

  describe("SSLContextFactory.createContext") {
    it("should throw an exception when keystore param is missing") {
      val thrown = the[RuntimeException] thrownBy SSLContextFactory.createContext(config.getConfig("spray.can.server").withoutPath("keystore"))
      thrown.getMessage should equal(SSLContextFactory.MISSING_KEYSTORE_MSG)
    }

    it("should throw an exception when keystore password param is missing") {
      val thrown = the[RuntimeException] thrownBy SSLContextFactory.createContext(config.getConfig("spray.can.server").withoutPath("keystorePW"))
      thrown.getMessage should equal(SSLContextFactory.MISSING_KEYSTORE_PASSWORD_MSG)
    }

    it("should throw an exception when keystore file cannot be found") {
      an[FileNotFoundException] should be thrownBy SSLContextFactory.createContext(config.getConfig("spray.can.server"))
    }

    it("should throw an exception when keystore file cannot be read") {
      val f = java.io.File.createTempFile("utgg", "jks")
      an[Exception] should be thrownBy
        SSLContextFactory.createContext(config.getConfig("spray.can.server").
          withValue("keystore", ConfigValueFactory.fromAnyRef(f.getAbsolutePath)))
    }

    it("should create default context when encryption is off") {
      val defaultContext = SSLContextFactory.createContext(config.getConfig("spray.can.server").
          withValue("ssl-encryption", ConfigValueFactory.fromAnyRef("off")))
      defaultContext should be (SSLContext.getDefault)
    }
  }

}
