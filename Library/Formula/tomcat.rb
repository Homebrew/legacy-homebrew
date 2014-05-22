require 'formula'

class Tomcat < Formula
  homepage 'http://tomcat.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-7/v7.0.53/bin/apache-tomcat-7.0.53.tar.gz'
  sha1 '269a01f03ed22e5ad7fa33dec300ef40cac96440'

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

  resource 'fulldocs' do
    url 'http://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-7/v7.0.53/bin/apache-tomcat-7.0.53-fulldocs.tar.gz'
    version '7.0.53'
    sha1 '4a6585ee59d7fef1e144652227986f9e390b048c'
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
