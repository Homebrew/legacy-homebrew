require 'formula'

class Tika < Formula
  homepage 'http://tika.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=tika/tika-app-1.8.jar'
  sha1 '0acf5fd2fd7ff410120d6d698b3c762d8bea83f1'

  resource 'server' do
    url 'http://repo1.maven.org/maven2/org/apache/tika/tika-server/1.8/tika-server-1.8.jar'
    sha1 '9b5c5550ff57433796dd9d8807ffb8f2f102bc91'
  end

  def install
    libexec.install "tika-app-#{version}.jar"
    bin.write_jar_script libexec/"tika-app-#{version}.jar", "tika"

    libexec.install resource('server')
    bin.write_jar_script libexec/"tika-server-#{version}.jar", "tika-rest-server"
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
