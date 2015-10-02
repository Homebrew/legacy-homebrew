# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://mercurial-scm.org/release/mercurial-3.5.2.tar.gz"
  sha256 "23fdc038503911b21dc9e556118803f7b1d4150eb14933d2ea3d0ff0dc60ab5d"

  bottle do
    cellar :any
    sha256 "8e22f11ff1c147a368581a424c0ec1f1b11959440f881597e84fcc031743ade0" => :el_capitan
    sha256 "c63ca0b939da4959f2623cac739876f3285683e92366f48a63371483254a6407" => :yosemite
    sha256 "f1c4e9ebbb056b50a584b760569de5cacdafbd728dd821e00297380ee5095904" => :mavericks
    sha256 "d39399222a31f040a5e22ef5853a9f99a476c1d76da85935710fdd80980d9ed5" => :mountain_lion
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
