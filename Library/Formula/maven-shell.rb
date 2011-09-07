require 'formula'

class MavenShell < Formula
  url 'http://repo1.maven.org/maven2/org/sonatype/maven/shell/dist/mvnsh-assembly/1.0.1/mvnsh-assembly-1.0.1-bin.tar.gz'
  homepage 'http://shell.sonatype.org/'
  md5 '5b0f47c8838aa7525f454f2bca9dbed9'

  def install
    # Remove windows files.
    rm_f Dir["bin/*.bat"]

    # Install jars in libexec to avoid conflicts.
    prefix.install %w{ NOTICE.txt LICENSE.txt README.txt }
    libexec.install Dir['*']

    # Symlink the boot script.
    bin.mkpath
    ln_s "#{libexec}/bin/mvnsh", bin+"mvnsh"
  end
end
