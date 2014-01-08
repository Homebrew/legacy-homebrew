require 'formula'

class Maven < Formula
  homepage 'http://maven.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=maven/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.tar.gz'
  sha1 '630eea2107b0742acb315b214009ba08602dda5f'

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Fix the permissions on the global settings file.
    chmod 0644, 'conf/settings.xml'

    prefix.install_metafiles
    libexec.install Dir['*']

    # Leave conf file in libexec. The mvn symlink will be resolved and the conf
    # file will be found relative to it
    bin.install_symlink Dir["#{libexec}/bin/*"] - ["#{libexec}/bin/m2.conf"]
  end
end
