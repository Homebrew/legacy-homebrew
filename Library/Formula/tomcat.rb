require 'formula'

class Tomcat < Formula
  homepage "http://tomcat.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.9/bin/apache-tomcat-8.0.9.tar.gz"
  sha1 "7218d06eab70e576de68a4d4d72ec4da34304676"

  bottle do
    cellar :any
    sha1 "8b23a12adb1580c0a3387f025129d56bfb39d02b" => :mavericks
    sha1 "487878aa241b5ccbee2c572c3ab6cc2bd3dfe969" => :mountain_lion
    sha1 "b3130515517c000ad0fc884155f7d1076023daae" => :lion
  end

  option "with-fulldocs", "Install full documentation locally"

  resource "fulldocs" do
    url "http://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.9/bin/apache-tomcat-8.0.9-fulldocs.tar.gz"
    version "8.0.9"
    sha1 "24abb690d63a62f6d914739268057a6f3d29d4df"
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
