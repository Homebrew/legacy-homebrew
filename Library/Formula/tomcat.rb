require 'formula'

class Tomcat < Formula
  homepage "http://tomcat.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.12/bin/apache-tomcat-8.0.12.tar.gz"
  sha1 "c93b8e769522b3984989471b4bf7dfbc4ae68f70"

  bottle do
    cellar :any
    sha1 "f2d16a34181aa40caf50e002d78a80f06b6142ec" => :mavericks
    sha1 "344c4c2a9c6c65a958232e322cb664e112f37809" => :mountain_lion
    sha1 "a64e5f007e094f992a6a2fa56bf8adbf5e6905ae" => :lion
  end

  option "with-fulldocs", "Install full documentation locally"

  resource "fulldocs" do
    url "http://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.12/bin/apache-tomcat-8.0.12-fulldocs.tar.gz"
    version "8.0.12"
    sha1 "e65aa4e03c91479aecfcaf21a5e4d99449706d3b"
  end

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
