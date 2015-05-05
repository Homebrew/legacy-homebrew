class Tomcat < Formula
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.22/bin/apache-tomcat-8.0.22.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.22/bin/apache-tomcat-8.0.22.tar.gz"
  sha256 "cb163576d03f45981bf025b62b46e71c3c634584daa4662fc721d37d46989eff"

  bottle do
    cellar :any
    sha256 "c416c992682342ee85e4fae48a9b07905081f579e53a566b94476cec634f039e" => :yosemite
    sha256 "330318f15b4d7cbbfb31377b7ead815cfde33135511d7e7c734e35bcbb931d4a" => :mavericks
    sha256 "a3abae652759bed842055c4335c47f43ee17d8d51187043ad84c8ba242bd7803" => :mountain_lion
  end

  option "with-fulldocs", "Install full documentation locally"

  resource "fulldocs" do
    url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.22/bin/apache-tomcat-8.0.22-fulldocs.tar.gz"
    mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.22/bin/apache-tomcat-8.0.22-fulldocs.tar.gz"
    version "8.0.22"
    sha256 "f1287f7a005180d8ff8b60461327554c9d5473d1d6784d97cbb4b580ef292c8c"
  end

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]

    # Install files
    prefix.install %w[ NOTICE LICENSE RELEASE-NOTES RUNNING.txt ]
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/catalina.sh" => "catalina"

    (share/"fulldocs").install resource("fulldocs") if build.with? "fulldocs"
  end
end
