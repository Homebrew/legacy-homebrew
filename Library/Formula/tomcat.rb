require 'formula'

class Tomcat < Formula
  homepage "http://tomcat.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.14/bin/apache-tomcat-8.0.14.tar.gz"
  sha1 "1a63a44dbf1b73f2256a2f21521b3d5ee3e8b5bf"

  bottle do
    cellar :any
    sha1 "100a590222ff8021ee2731a25c4fc0d524ce53ef" => :mavericks
    sha1 "8d8ea406e7210305877eef865acdb0f3e061f7e4" => :mountain_lion
    sha1 "33843f287d756cfde94709bca75a5f7485ada411" => :lion
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
