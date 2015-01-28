require 'formula'

class Tomcat < Formula
  homepage "http://tomcat.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.18/bin/apache-tomcat-8.0.18.tar.gz"
  sha1 "4c0232cac19a0a07d840258a975deec438038712"

  bottle do
    cellar :any
    sha1 "7bfb1b89afdeed253a724a4c3d2e112ba8b01fb0" => :yosemite
    sha1 "5b86437af62f3df9870634e20a22bf1ad0ce7d3e" => :mavericks
    sha1 "3006844e9d23c6253fbad346476c97694170d2d2" => :mountain_lion
  end

  option "with-fulldocs", "Install full documentation locally"

  resource "fulldocs" do
    url "http://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.18/bin/apache-tomcat-8.0.18-fulldocs.tar.gz"
    version "8.0.18"
    sha1 "162e717f450ae97b990906e6ff7734dc3bd9e083"
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
