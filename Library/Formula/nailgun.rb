class Nailgun < Formula
  desc "Command-line client, protocol and server for Java programs"
  homepage "http://www.martiansoftware.com/nailgun/"

  stable do
    url "https://github.com/martylamb/nailgun/archive/nailgun-all-0.9.1.tar.gz"
    sha256 "c487735b07f3d65e4c4d9bfa9aaef86d0d78128e4c055c6c24da818a4a47b2ab"

    resource "nailgun-jar" do
      url "https://search.maven.org/remotecontent?filepath=com/martiansoftware/nailgun-server/0.9.1/nailgun-server-0.9.1.jar"
      sha256 "4518faa6bf4bd26fccdc4d85e1625dc679381a08d56872d8ad12151dda9cef25"
    end

    # This patch just prepares the way for the next one.
    patch do
      url "https://github.com/martylamb/nailgun/commit/a789fa3f4eefcd24018d4fd89fc9037427533f52.diff"
      sha256 "98ca6e740d0814aaf0d2d6594d4a75ca3277d2283eb2d272bae1ba84b3337e8c"
    end

    # The makefile is not prefix aware
    patch do
      url "https://github.com/martylamb/nailgun/pull/45.diff"
      sha256 "8d6c0991d5fd557046a5462b0d59ca52933023082c5faff06ac901ba03e24db1"
    end
  end

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "02cf71ea505409aedd24b227d67b91a24dc1c2db040185424081ecfdb07f3382" => :el_capitan
    sha256 "958b5a30b72b237139cfd7723025f5d9f50f6b6a318fad22c3297f84a48c34eb" => :yosemite
    sha256 "395c49abe28e79d6171f616b2f0cacc317a95aa09123bdee3eae4df4f3249cff" => :mavericks
  end

  head do
    url "https://github.com/martylamb/nailgun.git"

    depends_on "maven" => :build

    # The -Xdoclint used in pom.xml causes a build error on Java 7
    patch do
      url "https://github.com/martylamb/nailgun/pull/70.diff"
      sha256 "b4bc4c33102c42ca5e37d22ad524085ccd33baafd225b9f0bc3b576aa6e8b983"
    end
  end

  def install
    system "make", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}", "CFLAGS=#{ENV.cflags}"
    if build.head?
      require 'rexml/document'
      pom_xml = REXML::Document.new(File.new("pom.xml"))
      jar_version = REXML::XPath.first(pom_xml, "string(/pom:project/pom:version)", "pom" => "http://maven.apache.org/POM/4.0.0")
      system "mvn", "clean", "install"
      libexec.install Dir["nailgun-server/target/*.jar"]
    else
      jar_version=version
      libexec.install resource("nailgun-jar").files("nailgun-server-#{version}.jar")
    end
    bin.write_jar_script libexec/"nailgun-server-#{jar_version}.jar", "ng-server", "-server"
  end

  test do
    fork { exec "ng-server", "8765" }
    sleep 1 # the server does not begin listening as fast as we can start a background process
    system "ng", "--nailgun-port", "8765", "ng-version"
    Kernel.system "ng", "--nailgun-port", "8765", "ng-stop"
    # ng-stop always returns a non-zero exit code even on successful exit
    true
  end
end

