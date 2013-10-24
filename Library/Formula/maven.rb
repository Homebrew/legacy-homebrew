require 'formula'

class Maven < Formula
  homepage 'http://maven.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=maven/maven-3/3.1.0/binaries/apache-maven-3.1.0-bin.tar.gz'
  sha1 'af0867027f0907631c1f85ecf668f74c08f5d5e9'

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Fix the permissions on the global settings file.
    chmod 0644, Dir["conf/settings.xml"]

    prefix.install_metafiles
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end
