class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tika/tika-app-1.10.jar"
  sha256 "21ac3c156c2b53c451599f1b2c441c7898fce8efb7e912f6894e5e543d7cd48c"

  depends_on :java => "1.7+"

  bottle do
    cellar :any
    sha256 "149bb5712c16304d1f71fa3047dd58ed9fa1b013679309ad2b2e03ea98d8d047" => :yosemite
    sha256 "b42c447ae4519b9663c94dbb64087e812a2123221778e4b60be34727a708994b" => :mavericks
    sha256 "f0295de87032c10300884c875427872c6b12368c19126342930c3770b3f95e77" => :mountain_lion
  end

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
