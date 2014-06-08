require 'formula'

# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  homepage 'http://mercurial.selenic.com/'
  url 'http://mercurial.selenic.com/release/mercurial-3.0.1.tar.gz'
  mirror 'http://fossies.org/linux/misc/mercurial-3.0.1.tar.gz'
  sha1 '2d257836d28d22e4da3d0ad72b0489f6587b1165'

  bottle do
    cellar :any
    sha1 "9bb19e521a3959bc4c1c60a9a446413657764f38" => :mavericks
    sha1 "734a6703d880bc7828b53eaf546df9d79ebac785" => :mountain_lion
    sha1 "87b4ea239964f96a4c7815a22f1422fff218d05b" => :lion
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
