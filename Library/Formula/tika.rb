require 'formula'

class TikaRestServer < Formula
  url 'http://repo1.maven.org/maven2/org/apache/tika/tika-server/1.4/tika-server-1.4.jar'
  sha1 '52c6a2ca5be920ead267ecce191b1644232244ee'
end

class Tika < Formula
  homepage 'http://tika.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=tika/tika-app-1.4.jar'
  sha1 'e91c758149ce9ce799fff184e9bf3aabda394abc'

  def install
    libexec.install "tika-app-#{version}.jar"
    bin.write_jar_script libexec/"tika-app-#{version}.jar", "tika"

    TikaRestServer.new.brew do |server|
      libexec.install "tika-server-#{server.version}.jar"
      bin.write_jar_script libexec/"tika-server-#{server.version}.jar", "tika-rest-server"
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
