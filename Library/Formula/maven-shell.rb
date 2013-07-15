require 'formula'

class MavenShell < Formula
  homepage 'http://shell.sonatype.org/'
  url 'http://repo1.maven.org/maven2/org/sonatype/maven/shell/dist/mvnsh-assembly/1.0.1/mvnsh-assembly-1.0.1-bin.tar.gz'
  sha1 'c8c7487689c53c1140d45d830c9e6d7d39f942c4'

  def install
    # Remove windows files.
    rm_f Dir["bin/*.bat"]

    prefix.install_metafiles
    libexec.install Dir['*']
    bin.install_symlink libexec/"bin/mvnsh"
  end
end
