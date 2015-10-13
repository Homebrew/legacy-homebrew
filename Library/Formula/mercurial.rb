# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://mercurial-scm.org/release/mercurial-3.5.2.tar.gz"
  sha256 "23fdc038503911b21dc9e556118803f7b1d4150eb14933d2ea3d0ff0dc60ab5d"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b3fd965bb4e294dab494ef4c719a634da9abf5743e962ec0ec6c50e97ae8eb6" => :el_capitan
    sha256 "a03e7ae949bb72374fed97d8c5516ef79d1e9b894df33253cfea34e38e0b656c" => :yosemite
    sha256 "75b4b9e659e3c9ef4822d77036991c3d7cba035c340eb4d8a56b93cd27ec84fc" => :mavericks
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
