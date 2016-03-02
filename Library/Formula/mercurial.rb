# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://mercurial-scm.org/release/mercurial-3.7.2.tar.gz"
  sha256 "5ba9438d6ab0db93f7b0786ba632138eb64a9dc0d93e30dde2b17b328fdc6d7a"

  bottle do
    cellar :any_skip_relocation
    sha256 "927a7d4d0b2abac34f90a2dd43d1d13ada47e301f489eaf463ef7065ffd88889" => :el_capitan
    sha256 "80f9441bae7dd750dcfbc6f4956245401519078526a19c048be1068723fc549b" => :yosemite
    sha256 "2d2621ab3c605052b9dd388525428a0a9d11c709d2f8a2d08701fc8fad77856d" => :mavericks
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
