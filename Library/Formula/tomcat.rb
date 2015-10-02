class Tomcat < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.27/bin/apache-tomcat-8.0.27.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.27/bin/apache-tomcat-8.0.27.tar.gz"
  sha256 "8ae7885596feb61d9f8944f928bcd6af7c799de33034fb7435c9991b34aa729a"

  bottle do
    cellar :any_skip_relocation
    sha256 "f596c50bc9ca7e1fc04785377feab5a1f7a89a79dc7ea7e89191e71879e2ce0d" => :el_capitan
    sha256 "0451222ba2341cba4152c5007967b536a6bf536c9cdd304ab9c2474dffe7b3b7" => :yosemite
    sha256 "9258495d4ced771aa184ac7811df80f9932db61cda28ba811e595b8c8167ccbc" => :mavericks
    sha256 "a1e6d8ed630f87bb5861f3fb0fadd97dc824d55fa3d689483779c14b3e2c7cfa" => :mountain_lion
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
