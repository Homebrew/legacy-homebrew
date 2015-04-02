# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  homepage "http://mercurial.selenic.com/"
  url "http://mercurial.selenic.com/release/mercurial-3.3.3.tar.gz"
  sha1 "999d5db4961e2c745f17df44d7ae64dce2d8425b"

  bottle do
    cellar :any
    sha256 "d8e1617d7b943d48d6e3db7d5792be749fa8aec4b3f5a6ff74ff1dc6f3253925" => :yosemite
    sha256 "cc932a8efa6ed7b34c1a52b29833e1a77a57ee452159f8008bc890343c16af98" => :mavericks
    sha256 "b9fbad5fcfd0e37496c613d3b9444d3c4ca66d7ab1deb9cf12c227c90d97d7ac" => :mountain_lion
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
