# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://mercurial-scm.org/release/mercurial-3.6.3.tar.gz"
  sha256 "402731f27256beb9a575a6991ca3d7059976197c905337f4f5729fd940329fa8"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4b872fbbe02995f6e8ea55a764e1a31b9008faa2b34c9697262a0b0538d4be6" => :el_capitan
    sha256 "8bdf939123b70cc67d6370d95a7312a16fb3a1aa1cdb0425832935017b60241e" => :yosemite
    sha256 "1efdd4f90c177922f039d2968c09abffc4c53b2c71c0f583cd500dafbaf9877d" => :mavericks
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
