class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tika/tika-app-1.10.jar"
  sha256 "21ac3c156c2b53c451599f1b2c441c7898fce8efb7e912f6894e5e543d7cd48c"

  resource "server" do
    url "https://repo1.maven.org/maven2/org/apache/tika/tika-server/1.10/tika-server-1.10.jar"
    sha256 "d1977896455d78c4a080886d460726393360329a4b8e7d0b290ee24571aede39"
  end

  def install
    libexec.install "tika-app-#{version}.jar"
    bin.write_jar_script libexec/"tika-app-#{version}.jar", "tika"

    libexec.install resource("server")
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
