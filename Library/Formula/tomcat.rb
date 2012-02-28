require 'formula'

class Tomcat < Formula
  homepage 'http://tomcat.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-7/v7.0.25/bin/apache-tomcat-7.0.25.tar.gz'
  md5 '2aa59d23555d641b20efad4aed86b693'

  skip_clean :all

  def install
    # Remove Windows scripts
    rm_rf Dir['bin/*.bat']

    # Install files
    prefix.install %w{ NOTICE LICENSE RELEASE-NOTES RUNNING.txt }
    libexec.install Dir['*']
    bin.install_symlink "#{libexec}/bin/catalina.sh" => "catalina"
  end
end
