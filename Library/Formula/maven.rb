require 'formula'

class Maven < Formula
  url 'http://www.apache.org/dyn/closer.cgi/maven/binaries/apache-maven-3.0.4-bin.tar.gz'
  homepage 'http://maven.apache.org/'
  md5 'e513740978238cb9e4d482103751f6b7'

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Fix the permissions on the global settings file.
    chmod 0644, Dir["conf/settings.xml"]

    # Install jars in libexec to avoid conflicts
    prefix.install %w{ NOTICE.txt LICENSE.txt README.txt }
    libexec.install Dir['*']

    # Symlink binaries
    bin.mkpath
    ln_s "#{libexec}/bin/mvn", bin+"mvn"
    ln_s "#{libexec}/bin/mvnDebug", bin+"mvnDebug"
    ln_s "#{libexec}/bin/mvnyjp", bin+"mvnyjp"
  end
end
