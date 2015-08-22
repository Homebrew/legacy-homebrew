class Tomcat < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.26/bin/apache-tomcat-8.0.26.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.26/bin/apache-tomcat-8.0.26.tar.gz"
  sha256 "9f11588f0ff767adde63cd6919462c0c2742897560f4b367a0ffffdd8b1ed382"

  bottle do
    cellar :any
    sha256 "7bb197d8b5e52f7efc3722d95d173d9ee16aaefa4e6286c30db638525578715a" => :yosemite
    sha256 "4c78185bf6d92448119eadb24485f3bc319384d9039e5e2e69c65f0f682a92b0" => :mavericks
    sha256 "c9ec44eb24910ad59eaa03a37f90440cd37dd8184004c14537d90109d5a03b76" => :mountain_lion
  end

  option "with-fulldocs", "Install full documentation locally"

  resource "fulldocs" do
    url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.26/bin/apache-tomcat-8.0.26-fulldocs.tar.gz"
    mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.26/bin/apache-tomcat-8.0.26-fulldocs.tar.gz"
    version "8.0.26"
    sha256 "813513d61e6def5ccf01adc95bf9d28594fce71ff32f5e23dc1482c7ec2f129b"
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
