class Tomcat < Formula
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.21/bin/apache-tomcat-8.0.21.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.21/bin/apache-tomcat-8.0.21.tar.gz"
  sha1 "957e88df8a9c3fc6b786321c4014b44c5c775773"

  bottle do
    cellar :any
    sha256 "c416c992682342ee85e4fae48a9b07905081f579e53a566b94476cec634f039e" => :yosemite
    sha256 "330318f15b4d7cbbfb31377b7ead815cfde33135511d7e7c734e35bcbb931d4a" => :mavericks
    sha256 "a3abae652759bed842055c4335c47f43ee17d8d51187043ad84c8ba242bd7803" => :mountain_lion
  end

  option "with-fulldocs", "Install full documentation locally"

  resource "fulldocs" do
    url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.21/bin/apache-tomcat-8.0.21-fulldocs.tar.gz"
    mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.21/bin/apache-tomcat-8.0.21-fulldocs.tar.gz"
    version "8.0.21"
    sha1 "3fc4db49c36846b4197810b7f26d07f5bdd17931"
  end

  def install
    # Remove Windows scripts
    rm_rf Dir['bin/*.bat']

    # Install files
    prefix.install %w{ NOTICE LICENSE RELEASE-NOTES RUNNING.txt }
    libexec.install Dir['*']
    bin.install_symlink "#{libexec}/bin/catalina.sh" => "catalina"

    (share/'fulldocs').install resource('fulldocs') if build.with? 'fulldocs'
  end
end
