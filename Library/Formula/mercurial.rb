require 'formula'

# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  homepage 'http://mercurial.selenic.com/'
  url 'http://mercurial.selenic.com/release/mercurial-3.1.tar.gz'
  mirror 'http://ftp.debian.org/debian/pool/main/m/mercurial/mercurial_3.1.orig.tar.gz'
  sha1 'aa95cd978c347ce7d5334c3280351ce03f861302'

  bottle do
    cellar :any
    sha1 "6d1af4bd6bdaca92ec8fbb8606b551b4366a6078" => :mavericks
    sha1 "d9e3b83bb5a3b3e9d753ef45a17aed079f3014da" => :mountain_lion
    sha1 "c494d609e6e60b52de9268ebd765814d2fceaeb0" => :lion
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
