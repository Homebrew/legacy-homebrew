require 'formula'

class Tomcat < Formula
  homepage "http://tomcat.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.15/bin/apache-tomcat-8.0.15.tar.gz"
  sha1 "e9b6c04f3d337a7a1e50acd175295b8c30e9d3b2"

  bottle do
    cellar :any
    sha1 "100a590222ff8021ee2731a25c4fc0d524ce53ef" => :mavericks
    sha1 "8d8ea406e7210305877eef865acdb0f3e061f7e4" => :mountain_lion
    sha1 "33843f287d756cfde94709bca75a5f7485ada411" => :lion
  end

  option "with-fulldocs", "Install full documentation locally"

  resource "fulldocs" do
    url "http://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.15/bin/apache-tomcat-8.0.15-fulldocs.tar.gz"
    version "8.0.15"
    sha1 "c010691b690f23b3320702f7a9b2fde51d885a44"
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
