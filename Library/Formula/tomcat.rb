class Tomcat < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.23/bin/apache-tomcat-8.0.23.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.23/bin/apache-tomcat-8.0.23.tar.gz"
  sha256 "c98b19a1edaaef2859991f304d0ec8f29c5ccacc6d63a0bc8bf7078d63191a38"

  bottle do
    cellar :any
    sha256 "5c43653281e5e7099230ebb76616583935538140b7802ec5d0fdbb719ccdc5e0" => :yosemite
    sha256 "caa72406f8f0f60d56dd656aa31e6170194df58d97c7f4661c93624771106c6b" => :mavericks
    sha256 "0fd6ba9c446dc1cf03c7dc1d537f61b879f8f1d194bf998cb1a0353a09e21831" => :mountain_lion
  end

  option "with-fulldocs", "Install full documentation locally"

  resource "fulldocs" do
    url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.23/bin/apache-tomcat-8.0.23-fulldocs.tar.gz"
    mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.23/bin/apache-tomcat-8.0.23-fulldocs.tar.gz"
    version "8.0.23"
    sha256 "bd0c85d48ccd6f0b7838e55215a7e553a8b9b58fd1a880560a7414940413f6d3"
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
