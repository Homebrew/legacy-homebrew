require 'formula'

class Groovyserv < Formula
  homepage 'http://kobo.github.com/groovyserv/'
  url 'https://bitbucket.org/kobo/groovyserv-mirror/downloads/groovyserv-0.11-src.zip'
  sha1 'a9a558c9793fbaaf32f6a4e267d5ad16d0381292'

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
