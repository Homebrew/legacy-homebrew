# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  homepage "http://mercurial.selenic.com/"
  url "http://mercurial.selenic.com/release/mercurial-3.3.tar.gz"
  sha1 "9bc03b6e82ce7bccb9d2608c7a5c4023adf2290c"

  bottle do
    cellar :any
    sha1 "7bb6b5981e4691e843fec9916dcc5462192f2f95" => :yosemite
    sha1 "5f774994e0d2dd796555669de2374b8e693d5fc5" => :mavericks
    sha1 "4919027d32f367e1b418b0798b4226bba76d3f56" => :mountain_lion
  end

  def install
    ENV.minimal_optimization if MacOS.version <= :snow_leopard

    system "make", "PREFIX=#{prefix}", "install-bin"
    # Install man pages, which come pre-built in source releases
    man1.install "doc/hg.1"
    man5.install "doc/hgignore.5", "doc/hgrc.5"

    # install the completion scripts
    bash_completion.install "contrib/bash_completion" => "hg-completion.bash"
    zsh_completion.install "contrib/zsh_completion" => "_hg"
  end

  test do
    system "#{bin}/hg", "init"
  end
end
