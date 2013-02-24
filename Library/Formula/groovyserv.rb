require 'formula'

class Groovyserv < Formula
  homepage 'http://kobo.github.com/groovyserv/'
<<<<<<< HEAD
  url 'https://github.com/downloads/kobo/groovyserv/groovyserv-0.10-src.zip'
<<<<<<< HEAD
  sha1 '1dd29a044338f1eb9dbb80369059a918de77e131'
=======
  sha1 'b8912ce7871458be6452876ab0215b5c89e82ad0'
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
=======
  url 'https://bitbucket.org/kobo/groovyserv-mirror/downloads/groovyserv-0.11-src.zip'
  sha1 'a9a558c9793fbaaf32f6a4e267d5ad16d0381292'
>>>>>>> 35b0414670cc73c4050f911c89fc1602fa6a1d40

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
