class Groovyserv < Formula
  desc "Speed up Groovy startup time"
  homepage "https://kobo.github.io/groovyserv/"
  url "https://bitbucket.org/kobo/groovyserv-mirror/downloads/groovyserv-1.0.0-src.zip"
  sha256 "2e684f589792aad638ef5391fbad7a6b3c2e7e1d7f35e098cb1d3d60a8b1882b"
  head "https://github.com/kobo/groovyserv.git"

  bottle do
    cellar :any
    sha256 "574847450b751be607198f21d470b5e7cd4693d1dafd634474700d121fc2b4eb" => :yosemite
    sha256 "891d92de6d33ca81ec885640a3a30b37749c272a2c69a37126e31bac2659b59c" => :mavericks
    sha256 "58a7a2dbd1327dd88b5a010b570140c479a1b28940769ac0cff644c7f19e11bb" => :mountain_lion
  end

  depends_on "go" => :build

  # This fix is upstream and can be removed in the next released version.
  patch do
    url "https://github.com/kobo/groovyserv/commit/4ea88fbfe940b50801be5e0b0bc84cd0ce627530.diff"
    sha256 "b7de43a030f97d8368ad9a9b895bd1242abc53c4ce0f12e7ab2acfc82e97da65"
  end

  def install
    # Sandbox fix to stop it ignoring our temporary $HOME variable.
    ENV["GRADLE_USER_HOME"] = buildpath/".brew_home"
    system "./gradlew", "clean", "executables"

    # Install executables in libexec to avoid conflicts
    libexec.install Dir["build/executables/{bin,lib}"]

    # Remove windows files
    rm_f Dir["#{libexec}/bin/*.bat"]

    # Symlink binaries except _common.sh
    bin.install_symlink Dir["#{libexec}/bin/g*"]
  end
end
