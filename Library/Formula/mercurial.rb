require "formula"

# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  homepage "http://mercurial.selenic.com/"
  url "http://mercurial.selenic.com/release/mercurial-3.2.3.tar.gz"
  sha1 "7c870aebcfd7720813c53c75b0939cee8a0e1168"

  bottle do
    cellar :any
    sha1 "6760a0ff6ac66c6a335a51f29a4358a2f3c9512e" => :yosemite
    sha1 "f5b87ea85b157bc19c7b86f579699eb381d30ea4" => :mavericks
    sha1 "b860e17d03f44d119dfb060807153a4e4b34e0a8" => :mountain_lion
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

    # install the merge tool default configs
    # http://mercurial.selenic.com/wiki/Packaging#Things_to_note
    (etc/"mercurial"/"hgrc.d").install "contrib/mergetools.hgrc" => "mergetools.rc"
  end

  test do
    system "#{bin}/hg", "init"
  end
end
