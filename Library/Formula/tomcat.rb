require 'formula'

class Tomcat < Formula
  homepage 'http://tomcat.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-7/v7.0.26/bin/apache-tomcat-7.0.26.tar.gz'
  md5 '00d310f2f4e15821951e9d206af45c6b'

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
