require 'formula'

# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  homepage 'http://mercurial.selenic.com/'
  url 'http://mercurial.selenic.com/release/mercurial-3.2.tar.gz'
  sha1 '9e003c4f7c188abc0c0f9d2b995e333884325027'

  bottle do
    cellar :any
    sha1 "4e6dd5a211b9848b65329b8658740d6fea94ba10" => :yosemite
    sha1 "e7cb271ead033df0986796c7217adaecec579b86" => :mavericks
    sha1 "993c20ef5f8a8bef388439a06ca3cfb0a6ad13e8" => :mountain_lion
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
