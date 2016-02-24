class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tika/tika-app-1.11.jar"
  sha256 "76f23849c0fe116efda3d89f9021d74415727f6f98b2860c24247c299cae719c"

  bottle :unneeded

  depends_on :java => "1.7+"

  resource "server" do
    url "https://repo1.maven.org/maven2/org/apache/tika/tika-server/1.11/tika-server-1.11.jar"
    sha256 "6eb6b932943d33860e533c3c8a4195f3b6376d3da07ff40e1aa299af5c705368"
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
