# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://mercurial-scm.org/release/mercurial-3.7.3.tar.gz"
  sha256 "c099c42d74e2d520b61dd372cd996b0fa7605c06617834fd7b13c79b9a9a5b30"

  bottle do
    cellar :any_skip_relocation
    sha256 "7104edcb38cdc3bf123ef2f79b5c1d6dc1a5777621a67e19e36ea125229849a6" => :el_capitan
    sha256 "7f9e3b1e222675410da1cbfb0dfbc26f44ec8f4b7bb5512dffdaac76aa8bffec" => :yosemite
    sha256 "480b4b6d0a45e95715241a6f7d650b305d9fe75eae00601daf5ce9cfe3741ea5" => :mavericks
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
