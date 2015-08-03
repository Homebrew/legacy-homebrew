class Groovyserv < Formula
  desc "Speed up Groovy startup time"
  homepage "https://kobo.github.io/groovyserv/"
  url "https://bitbucket.org/kobo/groovyserv-mirror/downloads/groovyserv-1.0.0-src.zip"
  sha256 "2e684f589792aad638ef5391fbad7a6b3c2e7e1d7f35e098cb1d3d60a8b1882b"
  head "https://github.com/kobo/groovyserv.git"

  bottle do
    cellar :any
    sha1 "2acd972802f63afcdebb622015ab059c23423789" => :yosemite
    sha1 "b2cb34764f861b8ef374ead20bac89f1866d03d4" => :mavericks
    sha1 "9936c0eadffe669dca07631c0609bc5a07968800" => :mountain_lion
  end

  depends_on "go" => :build

  # This fix is upstream and can be removed in the next released version.
  patch do
    url "https://github.com/kobo/groovyserv/commit/4ea88fbfe940b50801be5e0b0bc84cd0ce627530.diff"
    sha256 "b7de43a030f97d8368ad9a9b895bd1242abc53c4ce0f12e7ab2acfc82e97da65"
  end

  def install
    system "./gradlew", "clean" "executables"

    # Install executables in libexec to avoid conflicts
    libexec.install Dir["build/executables/{bin,lib}"]

    # Remove windows files
    rm_f Dir["#{libexec}/bin/*.bat"]

    # Symlink binaries except _common.sh
    bin.install_symlink Dir["#{libexec}/bin/g*"]
  end
end
