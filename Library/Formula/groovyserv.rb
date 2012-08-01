require 'formula'

class Groovyserv < Formula
  homepage 'http://kobo.github.com/groovyserv/'
  url 'https://github.com/downloads/kobo/groovyserv/groovyserv-0.10-src.zip'
  sha1 '1dd29a044338f1eb9dbb80369059a918de77e131'

  head 'https://github.com/kobo/groovyserv.git'

  depends_on 'groovy'

  def install
    ENV['CC'] = ENV['CFLAGS'] = nil # to workaround
    system './gradlew clean executables'

    prefix.install %w{LICENSE.txt README.txt NOTICE.txt}

    # Install executables in libexec to avoid conflicts
    libexec.install Dir["build/executables/{bin,lib}"]

    # Remove windows files
    rm_f Dir["#{libexec}/bin/*.bat"]

    # Symlink binaries
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end
