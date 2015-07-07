class Tomcat < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.24/bin/apache-tomcat-8.0.24.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.24/bin/apache-tomcat-8.0.24.tar.gz"
  sha256 "41980bdc3a0bb0abb820aa8ae269938946e219ae2d870f1615d5071564ccecee"

  bottle do
    cellar :any
    sha256 "5c43653281e5e7099230ebb76616583935538140b7802ec5d0fdbb719ccdc5e0" => :yosemite
    sha256 "caa72406f8f0f60d56dd656aa31e6170194df58d97c7f4661c93624771106c6b" => :mavericks
    sha256 "0fd6ba9c446dc1cf03c7dc1d537f61b879f8f1d194bf998cb1a0353a09e21831" => :mountain_lion
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
