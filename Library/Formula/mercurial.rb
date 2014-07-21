require 'formula'

# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  homepage 'http://mercurial.selenic.com/'
  url 'http://mercurial.selenic.com/release/mercurial-3.0.2.tar.gz'
  mirror 'http://fossies.org/linux/misc/mercurial-3.0.2.tar.gz'
  sha1 '5c6f28db8e483d8d948de5d4c5790b2462dfee1b'

  bottle do
    cellar :any
    sha1 "0d856360e1e42df9fd5b3cd977f8f8bfcbc351cb" => :mavericks
    sha1 "3099cb2e31d565c7bc0b14b82e4ee57d14d071f7" => :mountain_lion
    sha1 "84b223ebac837331be700c60777078e707652cec" => :lion
  end

  def install
    ENV.minimal_optimization if MacOS.version <= :snow_leopard

    system "make", "PREFIX=#{prefix}", "install-bin"
    # Install man pages, which come pre-built in source releases
    man1.install 'doc/hg.1'
    man5.install 'doc/hgignore.5', 'doc/hgrc.5'

    # install the completion scripts
    bash_completion.install 'contrib/bash_completion' => 'hg-completion.bash'
    zsh_completion.install 'contrib/zsh_completion' => '_hg'

    # install the merge tool default configs
    # http://mercurial.selenic.com/wiki/Packaging#Things_to_note
    (etc/"mercurial"/"hgrc.d").install "contrib/mergetools.hgrc" => "mergetools.rc"
  end

  test do
    system "#{bin}/hg", "init"
  end
end
