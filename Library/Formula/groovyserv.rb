require 'formula'

class Groovyserv < Formula
  homepage 'http://kobo.github.io/groovyserv/'
  url 'https://bitbucket.org/kobo/groovyserv-mirror/downloads/groovyserv-1.0.0-src.zip'
  sha1 '46b946dee3e40457e667498b235bd8e1567ed9ed'

  head 'https://github.com/kobo/groovyserv.git'
  depends_on "go" => :build

  # This fix is upstream and can be removed in the next released version.
  patch do
    url "https://github.com/kobo/groovyserv/commit/4ea88fbfe940b50801be5e0b0bc84cd0ce627530.diff"
    sha1 "2fe73bbed1778075a84dec43d462f69154cdb602"
  end

  def install
    system './gradlew clean executables'

    # Install executables in libexec to avoid conflicts
    libexec.install Dir["build/executables/{bin,lib}"]

    # Remove windows files
    rm_f Dir["#{libexec}/bin/*.bat"]

    # Symlink binaries except _common.sh
    bin.install_symlink Dir["#{libexec}/bin/g*"]
  end
end
