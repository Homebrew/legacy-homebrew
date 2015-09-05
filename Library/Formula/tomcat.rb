class Tomcat < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.26/bin/apache-tomcat-8.0.26.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.26/bin/apache-tomcat-8.0.26.tar.gz"
  sha256 "9f11588f0ff767adde63cd6919462c0c2742897560f4b367a0ffffdd8b1ed382"

  bottle do
    cellar :any
    sha256 "0451222ba2341cba4152c5007967b536a6bf536c9cdd304ab9c2474dffe7b3b7" => :yosemite
    sha256 "9258495d4ced771aa184ac7811df80f9932db61cda28ba811e595b8c8167ccbc" => :mavericks
    sha256 "a1e6d8ed630f87bb5861f3fb0fadd97dc824d55fa3d689483779c14b3e2c7cfa" => :mountain_lion
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
