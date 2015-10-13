class Tomcat < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.28/bin/apache-tomcat-8.0.28.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.28/bin/apache-tomcat-8.0.28.tar.gz"
  sha256 "a7a6c092b79fc5a8cffe5916d0e5554254eddcb3c1911ed90696c153b4f13d10"

  bottle do
    cellar :any_skip_relocation
    sha256 "d838813261b38243b1a4b6d3ccc1093061ad2b7731f461cbb67cf1ec02e53d0b" => :el_capitan
    sha256 "6a9b0dc7d2215969fc7c1ca905d872724639dda739bdbd4b2e7a6bc74049c066" => :yosemite
    sha256 "9e61553c732fb0009f48db1351921d457ea66c1d2d133e2e7ac9a4eacf656954" => :mavericks
  end

  option "with-fulldocs", "Install full documentation locally"

  resource "fulldocs" do
    url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.28/bin/apache-tomcat-8.0.28-fulldocs.tar.gz"
    mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.28/bin/apache-tomcat-8.0.28-fulldocs.tar.gz"
    version "8.0.28"
    sha256 "be503ea13eac5ca06bd028d1f768c5c935b060ac0a320cd9788408f2f2faa61f"
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
