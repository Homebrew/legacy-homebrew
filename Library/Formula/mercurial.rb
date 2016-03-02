# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://mercurial-scm.org/release/mercurial-3.7.2.tar.gz"
  sha256 "5ba9438d6ab0db93f7b0786ba632138eb64a9dc0d93e30dde2b17b328fdc6d7a"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9bf70e4cf144fd9f3a69f8598cec3947e7312d04ba0b5a08b8dc6ecc88ba4fc" => :el_capitan
    sha256 "f3a0fccd96694425b6a12ebf402a475ecb37ac72b3c47c771f877bee856cd114" => :yosemite
    sha256 "53036c632fdfd35d7ccdb85756660e8eeb01437afa6ce68ea35291361bf941ea" => :mavericks
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
