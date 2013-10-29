require 'formula'

class Tomcat < Formula
  homepage 'http://tomcat.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-7/v7.0.47/bin/apache-tomcat-7.0.47.tar.gz'
  sha1 'ea54881535fccb3dfd7da122358d983297d69196'

  devel do
    url 'http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.0-RC5/bin/apache-tomcat-8.0.0-RC5.tar.gz'
    sha1 '17d310f962f0ce2de3956b122f5c604d97a87565'
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
  end
end
