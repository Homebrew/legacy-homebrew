class Tomcat < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.24/bin/apache-tomcat-8.0.24.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.24/bin/apache-tomcat-8.0.24.tar.gz"
  sha256 "41980bdc3a0bb0abb820aa8ae269938946e219ae2d870f1615d5071564ccecee"

  bottle do
    cellar :any
    sha256 "7bb197d8b5e52f7efc3722d95d173d9ee16aaefa4e6286c30db638525578715a" => :yosemite
    sha256 "4c78185bf6d92448119eadb24485f3bc319384d9039e5e2e69c65f0f682a92b0" => :mavericks
    sha256 "c9ec44eb24910ad59eaa03a37f90440cd37dd8184004c14537d90109d5a03b76" => :mountain_lion
  end

  option "with-fulldocs", "Install full documentation locally"

  resource "fulldocs" do
    url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.24/bin/apache-tomcat-8.0.24-fulldocs.tar.gz"
    mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.24/bin/apache-tomcat-8.0.24-fulldocs.tar.gz"
    version "8.0.24"
    sha256 "ece5676b8f51c3009cf3da3d2eeaacf941f7174e41a183877c7a5ffd7295b855"
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
