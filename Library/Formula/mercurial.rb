# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  homepage "http://mercurial.selenic.com/"
  url "http://mercurial.selenic.com/release/mercurial-3.4.1.tar.gz"
  sha256 "7a8acf7329beda38ceea29c689212574d9a6bfffe24cf565015ea0066f7cee3f"

  bottle do
    cellar :any
    sha256 "073cf23fa2ff34cc66ce99c8535fcce979453e402802d483ebccf2d60d323d58" => :yosemite
    sha256 "76fce90c4a1759495935a23fa8c515e844b08648f08ffd1d35adeb303bb47de6" => :mavericks
    sha256 "fcac735e0d359616c6bd89f8b6966b8bf7a005af788716c5561a8b434ebb099b" => :mountain_lion
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
