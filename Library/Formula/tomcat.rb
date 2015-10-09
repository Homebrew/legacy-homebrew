class Tomcat < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.27/bin/apache-tomcat-8.0.27.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.27/bin/apache-tomcat-8.0.27.tar.gz"
  sha256 "8ae7885596feb61d9f8944f928bcd6af7c799de33034fb7435c9991b34aa729a"

  bottle do
    cellar :any_skip_relocation
    sha256 "9527e81cd1c5dce42630c37a7e2288631ae51da5b92f217267a9e45071631725" => :el_capitan
    sha256 "b4609e5691ffb81883f1150db5ea422779bd6dc6eeb597b3a7b0e6c18742cce8" => :yosemite
    sha256 "401df2c611200e8f2d2d15775676f2a8f187a5c9b5d441d5bf4a9125773acbd0" => :mavericks
  end

  option "with-fulldocs", "Install full documentation locally"

  resource "fulldocs" do
    url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.27/bin/apache-tomcat-8.0.27-fulldocs.tar.gz"
    mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.27/bin/apache-tomcat-8.0.27-fulldocs.tar.gz"
    version "8.0.27"
    sha256 "4707b2c2f8c5b241001f8909bb52791d77aee1a481abd4c0065283477d75bee9"
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
