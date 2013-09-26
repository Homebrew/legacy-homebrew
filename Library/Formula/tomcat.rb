require 'formula'

class Tomcat < Formula
  homepage 'http://tomcat.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-7/v7.0.42/bin/apache-tomcat-7.0.42.tar.gz'
  sha1 '001a64629a93103d4f53ac95faf3e52a63657b95'

  devel do
    url 'http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.0-RC3/bin/apache-tomcat-8.0.0-RC3.tar.gz'
    sha1 'a6a7df2358851c50bcfe1e5ddf0f42a13de2756a'
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
