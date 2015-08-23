# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial.selenic.com/"
  url "https://mercurial.selenic.com/release/mercurial-3.5.tar.gz"
  sha256 "b50f6978e7d39fe0cb298fa3fa3e9ce41d2356721d155e5288f9c57e5f13e9a7"

  bottle do
    cellar :any
    revision 2
    sha256 "eaf7343005f12a18afd3a89b4a544bc3a4030b31f4c79d6b8bfafe22394174bd" => :yosemite
    sha256 "8f7d6f7164a9733748601a773d8ac7728746a0b11f6c91d6689e7f99aa605310" => :mavericks
    sha256 "909661f928983f83e79433d45a8a73b2b4fdc155e712edfb25fd245a50dc41cc" => :mountain_lion
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
