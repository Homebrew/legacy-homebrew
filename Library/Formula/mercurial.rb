# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial.selenic.com/"
  url "https://mercurial.selenic.com/release/mercurial-3.5.tar.gz"
  sha256 "b50f6978e7d39fe0cb298fa3fa3e9ce41d2356721d155e5288f9c57e5f13e9a7"

  bottle do
    cellar :any
    sha256 "d16c70f4308b1faccad2597f958660a91c6543af232e34ee75c0d02aa509c7c1" => :yosemite
    sha256 "147552340e74532e30fb3a81b884c3da2cfc864853f9fc5632316d971fa7a9c2" => :mavericks
    sha256 "bab3981ab5525491cde27a0df3686d303a2e80b4f9796bbdff6681b9d4b8637f" => :mountain_lion
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
