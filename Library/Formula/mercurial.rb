# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial.selenic.com/"
  url "https://mercurial.selenic.com/release/mercurial-3.5.tar.gz"
  sha256 "b50f6978e7d39fe0cb298fa3fa3e9ce41d2356721d155e5288f9c57e5f13e9a7"

  bottle do
    cellar :any
    revision 1
    sha256 "e898db2838af928886d849f5d3db058189824eabb469d5b950bacf62f47c624b" => :yosemite
    sha256 "70febfeb93a25fddf1a53f081ce129347f3896893ec6ff4f0acb93d7bfcc6aed" => :mavericks
    sha256 "43e273e2a20d66d05e25505578949b042257df64bfe731d4a5e7d1b37b3c4c0c" => :mountain_lion
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
