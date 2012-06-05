require 'formula'

class Groovyserv < Formula
  homepage 'http://kobo.github.com/groovyserv/'
  url 'https://github.com/downloads/kobo/groovyserv/groovyserv-0.9-src.zip'
  sha1 '54464608f90a381b44cf7959136e1b1f31a3919c'

  head 'https://github.com/kobo/groovyserv.git'

  depends_on 'gradle' => :build
  depends_on 'groovy'

  def install
    system 'gradle clean executables'

    prefix.install %w{LICENSE.txt README.txt NOTICE.txt}

    # Install executables in libexec to avoid conflicts
    libexec.install Dir["build/executables/{bin,lib}"]

    # Remove windows files
    rm_f Dir["#{libexec}/bin/*.bat"]

    # Symlink binaries
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end
