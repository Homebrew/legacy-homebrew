require 'formula'

# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  homepage 'http://mercurial.selenic.com/'
  url 'http://mercurial.selenic.com/release/mercurial-3.1.2.tar.gz'
  sha1 'ae7e16454cee505da895c2497f09711f35287459'

  bottle do
    cellar :any
    sha1 "eb85a4ea16c6dfef0b75e1e067f5374acbfe862c" => :mavericks
    sha1 "e99b0565dcdfb888f6f976c6b9abeae38b79adb0" => :mountain_lion
    sha1 "764e5c61bebd9f79a86c8fa79bc743c8d508e4d8" => :lion
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
