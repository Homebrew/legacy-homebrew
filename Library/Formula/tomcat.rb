require 'formula'

class Tomcat < Formula
  homepage "http://tomcat.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.15/bin/apache-tomcat-8.0.15.tar.gz"
  sha1 "e9b6c04f3d337a7a1e50acd175295b8c30e9d3b2"

  bottle do
    cellar :any
    sha1 "afcce9cce701aa992521e912a64820c5cf281d76" => :yosemite
    sha1 "31ac8950914cd7cb17d51979d2e51c10e5071443" => :mavericks
    sha1 "f4f9f3a45f15ff71e8f7a8c5468227cfc374f158" => :mountain_lion
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
