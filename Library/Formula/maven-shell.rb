require 'formula'

class MavenShell < Formula
  desc "A shell for Maven"
  homepage 'http://shell.sonatype.org/'
  url 'http://repo1.maven.org/maven2/org/sonatype/maven/shell/dist/mvnsh-assembly/1.1.0/mvnsh-assembly-1.1.0-bin.tar.gz'
  sha1 '0aa91e810be695952f56e7369c00d9e4bf1a3ead'

  def install
    # Remove windows files.
    rm_f Dir["bin/*.bat"]

    prefix.install_metafiles
    libexec.install Dir['*']
    bin.install_symlink libexec/"bin/mvnsh"
  end
end
