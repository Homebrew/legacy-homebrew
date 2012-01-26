require 'formula'

class Tomcat < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-7/v7.0.25/bin/apache-tomcat-7.0.25.tar.gz'
  homepage 'http://tomcat.apache.org/'
  md5 '2aa59d23555d641b20efad4aed86b693'

  skip_clean :all

  def install
    # Remove Windows scripts
    rm_rf Dir['bin/*.bat']

    # Install files
    prefix.install %w{ NOTICE LICENSE RELEASE-NOTES RUNNING.txt }
    libexec.install Dir['*']

    # Symlink binaries
    bin.mkpath
    ln_s "#{libexec}/bin/catalina.sh", bin+"catalina"
  end
end
