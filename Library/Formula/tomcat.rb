require 'formula'

class Tomcat < Formula
  homepage 'http://tomcat.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-7/v7.0.50/bin/apache-tomcat-7.0.50.tar.gz'
  sha1 '5f8d82b6f142a7b4936680a6bd774bb7330b862e'

  option "with-fulldocs", "Install full documentation locally"

  devel do
    url 'http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.0-RC10/bin/apache-tomcat-8.0.0-RC10.tar.gz'
    sha1 'c6a8dc2a62dd6a3980d30ca2961c283c39e28ebe'

    resource 'fulldocs' do
      url 'http://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.0-RC10/bin/apache-tomcat-8.0.0-RC10-fulldocs.tar.gz'
      version '8.0.0-RC10'
      sha1 'a1859e67f6aa70e448d7db8901b0fc5bc4051aa6'
    end
  end

  resource 'fulldocs' do
    url 'http://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-7/v7.0.50/bin/apache-tomcat-7.0.50-fulldocs.tar.gz'
    version '7.0.50'
    sha1 '86a913223582f7c7e4fbf8d88f89870f5b1fd81b'
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
