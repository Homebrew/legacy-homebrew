# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  homepage "http://mercurial.selenic.com/"
  url "http://mercurial.selenic.com/release/mercurial-3.3.2.tar.gz"
  sha1 "53b51d5c1e365bd8e77b29bf38c730b70df597ad"

  bottle do
    cellar :any
    sha256 "c25a2345484c187a6a2c553ad039d8f7ad9d670c517020bf3404d67dd616b01d" => :yosemite
    sha256 "0f3ba7b46785658b88b12135e444f95c16a47eaab52da24c8661dc24d044f6dc" => :mavericks
    sha256 "2395f5ad62de07a4196947285ff9cd0c0542ad72527734e292e68806e7c77315" => :mountain_lion
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
