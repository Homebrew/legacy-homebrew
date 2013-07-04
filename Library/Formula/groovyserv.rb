require 'formula'

class Groovyserv < Formula
  homepage 'http://kobo.github.io/groovyserv/'
  url 'https://bitbucket.org/kobo/groovyserv-mirror/downloads/groovyserv-0.12-src.zip'
  sha1 '13d28359d19cdbf380ac45a4c4aeb62af317bd3e'

  head 'https://github.com/kobo/groovyserv.git'

  def install
    system './gradlew clean executables'

    # Install executables in libexec to avoid conflicts
    libexec.install Dir["build/executables/{bin,lib}"]

    # Remove windows files
    rm_f Dir["#{libexec}/bin/*.bat"]

    # Symlink binaries
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end
