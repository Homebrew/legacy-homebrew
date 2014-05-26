require 'formula'

class Tomcat < Formula
  homepage "http://tomcat.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-7/v7.0.54/bin/apache-tomcat-7.0.54.tar.gz"
  sha1 "b0db037619c5c10cbe8d17f7a1492fd759fa5805"

  bottle do
    cellar :any
    sha1 "8b23a12adb1580c0a3387f025129d56bfb39d02b" => :mavericks
    sha1 "487878aa241b5ccbee2c572c3ab6cc2bd3dfe969" => :mountain_lion
    sha1 "b3130515517c000ad0fc884155f7d1076023daae" => :lion
  end

  option "with-fulldocs", "Install full documentation locally"

  devel do
    url "http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.8/bin/apache-tomcat-8.0.8.tar.gz"
    sha1 "4cca8a0a296f76d45d0b807a03ad956e6bb8a02b"

    resource "fulldocs" do
      url "http://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.8/bin/apache-tomcat-8.0.8-fulldocs.tar.gz"
      version "8.0.8"
      sha1 "a8d98a65e7904047ae8ca5f5dea8a42d0e0491ac"
    end
  end

  resource "fulldocs" do
    url "http://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-7/v7.0.54/bin/apache-tomcat-7.0.54-fulldocs.tar.gz"
    version "7.0.54"
    sha1 "2b2dc6835ebcaf12705cd3e60c40114e498651f0"
  end

  # Keep log folders
  skip_clean 'libexec'

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
