require 'formula'

class Tomcat < Formula
  homepage "http://tomcat.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.17/bin/apache-tomcat-8.0.17.tar.gz"
  sha1 "3e967565aebc5870b90c27c6fb2b76618c3c26da"

  bottle do
    cellar :any
    sha1 "afcce9cce701aa992521e912a64820c5cf281d76" => :yosemite
    sha1 "31ac8950914cd7cb17d51979d2e51c10e5071443" => :mavericks
    sha1 "f4f9f3a45f15ff71e8f7a8c5468227cfc374f158" => :mountain_lion
  end

  option "with-fulldocs", "Install full documentation locally"

  resource "fulldocs" do
    url "http://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.17/bin/apache-tomcat-8.0.17-fulldocs.tar.gz"
    version "8.0.17"
    sha1 "6111724deb66508c6d2d501118c807d393cde982"
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
