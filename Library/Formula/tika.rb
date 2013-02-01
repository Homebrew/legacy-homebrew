require 'formula'

class TikaRestServer < Formula
  url 'http://repo1.maven.org/maven2/org/apache/tika/tika-server/1.3/tika-server-1.3.jar'
  sha1 '8d96bc0fa171c48018ebdce62f1204cb79de250b'
end

class Tika < Formula
  homepage 'http://tika.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=tika/tika-app-1.3.jar'
  sha1 'fb5786dfe4fa19a651c9f6d9417336127b34ddc2'

  def install
    libexec.install "tika-app-#{version}.jar"
    bin.write_jar_script libexec/"tika-app-1.3.jar", "tika"
    TikaRestServer.new.brew do
      libexec.install "tika-server-1.3.jar"
      bin.write_jar_script libexec/"tika-server-1.3.jar", "tika-rest-server"
    end
  end

  def caveats; <<-EOS.undent
    To run Tika:
      tika

    To run Tika's REST server:
      tika-rest-server

    See the Tika homepage for more documentation:
      brew home tika
    EOS
  end
end
