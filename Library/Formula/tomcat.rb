require 'formula'

class Tomcat < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-7/v7.0.20/bin/apache-tomcat-7.0.20.tar.gz'
  homepage 'http://tomcat.apache.org/'
  md5 'e6a8b71d334d28a471682ee02fd08b91'

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
