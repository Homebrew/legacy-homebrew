class MavenShell < Formula
  desc "Shell for Maven"
  homepage "http://shell.sonatype.org/"
  url "https://repo1.maven.org/maven2/org/sonatype/maven/shell/dist/mvnsh-assembly/1.1.0/mvnsh-assembly-1.1.0-bin.tar.gz"
  sha256 "584008d726bf6f90271f4ccd03b549773cbbe62ba7e92bf131e67df3ac5a41ac"

  bottle :unneeded

  def install
    # Remove windows files.
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/mvnsh"
  end
end
