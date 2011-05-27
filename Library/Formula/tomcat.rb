require 'formula'

class Tomcat < Formula
  url 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.14/bin/apache-tomcat-7.0.14.tar.gz'
  homepage 'http://tomcat.apache.org/'
  md5 '6a4f1b7285b7366250c4e09307594451'

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
