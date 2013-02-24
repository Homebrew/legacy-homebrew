require 'formula'

class Maven < Formula
  homepage 'http://maven.apache.org/'
  url 'http://mirror.quintex.com/apache/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz'
  md5 '94c51f0dd139b4b8549204d0605a5859'

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
