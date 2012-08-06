require 'formula'

class Groovyserv < Formula
  homepage 'http://kobo.github.com/groovyserv/'
  url 'https://github.com/downloads/kobo/groovyserv/groovyserv-0.10-src.zip'
  sha1 'b8912ce7871458be6452876ab0215b5c89e82ad0'

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
