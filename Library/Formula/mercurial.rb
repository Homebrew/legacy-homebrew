require 'formula'

# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  homepage 'http://mercurial.selenic.com/'
  url 'http://mercurial.selenic.com/release/mercurial-3.0.tar.gz'
  mirror 'http://fossies.org/linux/misc/mercurial-3.0.tar.gz'
  sha1 'f9648580dd1a6a093fa16d7c28cf5aeefd20f2f0'

  resource "docutils" do
    url "https://pypi.python.org/packages/source/d/docutils/docutils-0.11.tar.gz"
    sha1 "3894ebcbcbf8aa54ce7c3d2c8f05460544912d67"
  end

  def install
    ENV.minimal_optimization if MacOS.version <= :snow_leopard

    (buildpath/"doc").install resource("docutils").files("docutils")

    system "make", "doc", "PREFIX=#{prefix}"
    system "make", "install-doc", "PREFIX=#{prefix}"

    system "make", "PREFIX=#{prefix}", "install-bin"
    # Install man pages, which come pre-built in source releases
    man1.install 'doc/hg.1'
    man5.install 'doc/hgignore.5', 'doc/hgrc.5'

    # install the completion scripts
    bash_completion.install 'contrib/bash_completion' => 'hg-completion.bash'
    zsh_completion.install 'contrib/zsh_completion' => '_hg'
  end

  test do
    system "#{bin}/hg", "init"
  end
end
