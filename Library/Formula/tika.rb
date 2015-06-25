require 'formula'

class Tika < Formula
  desc "Content analysis toolkit"
  homepage 'https://tika.apache.org/'
  url 'https://www.apache.org/dyn/closer.cgi?path=tika/tika-app-1.9.jar'
  sha256 'b67bb2d3979517c5e1f43e865e8ba8f55a70dcce20fae7d4c4437c5906181fc8'

  resource 'server' do
    url 'https://repo1.maven.org/maven2/org/apache/tika/tika-server/1.9/tika-server-1.9.jar'
    sha256 'ae20919b4ab150613bf5c1037031aef0920c0755fff96523e3ed3ccbc89ca7c6'
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
