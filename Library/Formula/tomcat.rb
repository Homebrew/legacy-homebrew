class Tomcat < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.28/bin/apache-tomcat-8.0.28.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.28/bin/apache-tomcat-8.0.28.tar.gz"
  sha256 "a7a6c092b79fc5a8cffe5916d0e5554254eddcb3c1911ed90696c153b4f13d10"

  bottle do
    cellar :any_skip_relocation
    sha256 "9527e81cd1c5dce42630c37a7e2288631ae51da5b92f217267a9e45071631725" => :el_capitan
    sha256 "b4609e5691ffb81883f1150db5ea422779bd6dc6eeb597b3a7b0e6c18742cce8" => :yosemite
    sha256 "401df2c611200e8f2d2d15775676f2a8f187a5c9b5d441d5bf4a9125773acbd0" => :mavericks
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
