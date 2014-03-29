require 'formula'

class Tomcat < Formula
  homepage 'http://tomcat.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-7/v7.0.52/bin/apache-tomcat-7.0.52.tar.gz'
  sha1 'adb171c420a6b0a042e2102a76fb70ac4da06a44'

  option "with-fulldocs", "Install full documentation locally"

  devel do
    url "http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.5/bin/apache-tomcat-8.0.5.tar.gz"
    sha1 "dc21157e8577132999f090859be2c4468e841c23"

    resource "fulldocs" do
      url "http://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.5/bin/apache-tomcat-8.0.5-fulldocs.tar.gz"
      version "8.0.5"
      sha1 "8d27a447e1d38d6491d47e15d66c4bc9b03ef55f"
    end
  end

  resource 'fulldocs' do
    url 'http://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-7/v7.0.52/bin/apache-tomcat-7.0.52-fulldocs.tar.gz'
    version '7.0.52'
    sha1 'a635011c8d3643c595102850740d0290f37f44b5'
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
