package ooyala.common.akka.web

import javax.net.ssl.SSLContext
import spray.io._
import java.security.KeyStore
import java.io.FileInputStream
import javax.net.ssl.KeyManagerFactory
import javax.net.ssl.TrustManagerFactory
import javax.net.ssl.TrustManager
import org.slf4j.LoggerFactory
import javax.net.ssl.X509TrustManager

/**
 * based on
 * https://github.com/spray/spray/blob/v1.2-M8/examples/
 * spray-can/simple-http-server/src/main/scala/spray/examples/MySslConfiguration.scala
 */
trait MySSLConfig {

  implicit def sslContext: SSLContext = {

    val ksName = "spray.can.server.kestore"
    val myPass = "spray.can.server.kestorePW".toCharArray()
    val ks = KeyStore.getInstance("JKS")
    ks.load(new FileInputStream(ksName), myPass);
    val kmf = KeyManagerFactory.getInstance("SunX509");
    kmf.init(ks, myPass);

    val sslContext = SSLContext.getInstance("SSL") //TLS?

    sslContext.init(kmf.getKeyManagers(), null, null);
    sslContext
  }

  implicit def sslEngineProvider: ServerSSLEngineProvider = {
    ServerSSLEngineProvider { engine =>
      engine.setEnabledProtocols(Array("SSLv3", "TLSv1"))
      engine
    }
  }
}
