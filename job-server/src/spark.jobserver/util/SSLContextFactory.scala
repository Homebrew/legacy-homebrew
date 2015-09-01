package spark.jobserver.util

import javax.net.ssl.SSLContext
import javax.net.ssl.KeyManagerFactory
import java.security.KeyStore
import java.io.FileInputStream
import com.typesafe.config.Config
import org.slf4j.LoggerFactory

/**
 * creates SSLContext based on configuration, the SSLContext is used for communication between
 * the SJS web server and its clients
 *
 * if encryption is not activated in the configuration, then the default ssl context is used which
 * falls back to un-encrypted communication
 */
object SSLContextFactory {
  val logger = LoggerFactory.getLogger(getClass)

  /**
   * based on
   * https://github.com/spray/spray/blob/v1.2-M8/examples/
   * spray-can/simple-http-server/src/main/scala/spray/examples/MySslConfiguration.scala
   */
  def createContext(config: Config): SSLContext = {
    if (config.hasPath("ssl-encryption") &&
      config.getBoolean("ssl-encryption")) {

      checkRequiredParamsSet(config)
      val sslContext = SSLContext.getInstance(config.getString("encryptionType"))

      val ksName = config.getString("keystore")
      val ksPassphrase = config.getString("keystorePW").toCharArray()
      val keystoreType = config.getString("keystoreType")
      val encryptionType = config.getString("encryptionType")
      logger.info(encryptionType + " encryption activated.")
      val ks = KeyStore.getInstance(keystoreType)
      //throws exception if keystore cannot be found or accessed
      // and prevents start-up
      ks.load(new FileInputStream(ksName), ksPassphrase)
      val kmf = KeyManagerFactory.getInstance(config.getString("provider"))
      kmf.init(ks, ksPassphrase)
      sslContext.init(kmf.getKeyManagers(), null, null)

      sslContext
    } else {
      SSLContext.getDefault
    }
  }

  val MISSING_KEYSTORE_MSG = "Configuration error (param 'keystore'): ssl/tsl encryption is " +
    "activated, but keystore location is not configured."
  val MISSING_KEYSTORE_PASSWORD_MSG = "Configuration error (param 'keystorePW'): ssl/tsl encryption is " +
    "activated, but keystore password is not configured."

  def checkRequiredParamsSet(config: Config) {
    //all other parameters have default values in application.conf
    if (!config.hasPath("keystore")) {
      throw new RuntimeException(MISSING_KEYSTORE_MSG)
    }
    if (!config.hasPath("keystorePW")) {
      throw new RuntimeException(MISSING_KEYSTORE_PASSWORD_MSG)
    }
  }
}
