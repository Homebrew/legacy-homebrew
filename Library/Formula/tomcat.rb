require 'formula'

class Tomcat < Formula
  homepage "http://tomcat.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.14/bin/apache-tomcat-8.0.14.tar.gz"
  sha1 "1a63a44dbf1b73f2256a2f21521b3d5ee3e8b5bf"

  bottle do
    cellar :any
    sha1 "f2d16a34181aa40caf50e002d78a80f06b6142ec" => :mavericks
    sha1 "344c4c2a9c6c65a958232e322cb664e112f37809" => :mountain_lion
    sha1 "a64e5f007e094f992a6a2fa56bf8adbf5e6905ae" => :lion
  end

  option "with-fulldocs", "Install full documentation locally"

  resource "fulldocs" do
    url "http://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.14/bin/apache-tomcat-8.0.14-fulldocs.tar.gz"
    version "8.0.14"
    sha1 "181b01c6d0be3dee5dea5dc12e38f5f0f3c2a72a"
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
