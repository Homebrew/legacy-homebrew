require "formula"

class Nailgun < Formula
  homepage "http://www.martiansoftware.com/nailgun/"
  url "https://github.com/martylamb/nailgun/archive/nailgun-all-0.9.1.tar.gz"
  sha1 "75f21504e8a6d41f263560b74c33188e91ec1a27"

  resource "nailgun-jar" do
    url "http://central.maven.org/maven2/com/martiansoftware/nailgun-server/0.9.1/nailgun-server-0.9.1.jar"
    sha1 "d57ea0a6f6c1bb1b616c5b3b311b3726c6ff35ad"
  end

  def install
    system "make"
    bin.install "ng"
    resource("nailgun-jar").stage { libexec.install "nailgun-server-#{version}.jar" }
    bin.write_jar_script libexec/"nailgun-server-#{version}.jar", "ng-server", "-server"
  end

  test do
    t = Thread.new { system "ng-server 8765" }
    sleep 0.2 # the server does not begin listening as fast as we can start a background process
    system "ng", "--nailgun-port", "8765", "ng-version"
    # ng-stop always returns a non-zero exit code even on successful exit
    `ng --nailgun-port 8765 ng-stop || true`
    t.join
  end
end
