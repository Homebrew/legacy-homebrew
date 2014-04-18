require 'formula'

class Mercurial < Formula
  homepage 'http://mercurial.selenic.com/'
  url 'http://mercurial.selenic.com/release/mercurial-2.9.2.tar.gz'
  mirror 'http://fossies.org/linux/misc/mercurial-2.9.2.tar.gz'
  sha1 '35668f2d88afe55d10aa7dbce821021bf0be4f73'

  head 'http://selenic.com/repo/hg', :using => :hg

  option 'enable-docs', "Build the docs (and require docutils)"

  depends_on :python
  depends_on 'docutils' => :python if build.include? 'enable-docs'

  def install
    ENV.minimal_optimization if MacOS.version <= :snow_leopard
    if build.include? 'enable-docs'
      system "make", "doc", "PREFIX=#{prefix}"
      system "make", "install-doc", "PREFIX=#{prefix}"
    end

    system "make", "PREFIX=#{prefix}", "install-bin"
    # Install man pages, which come pre-built in source releases
    man1.install 'doc/hg.1'
    man5.install 'doc/hgignore.5', 'doc/hgrc.5'

    # install the completion scripts
    bash_completion.install 'contrib/bash_completion' => 'hg-completion.bash'
    zsh_completion.install 'contrib/zsh_completion' => '_hg'
  end

  def caveats
    if build.head?; <<-EOS.undent
      To install the --HEAD version of mercurial, you have to:
        1. `brew install mercurial`  # so brew can use this to fetch sources!
        2. `brew unlink mercurial`
        3. `brew install mercurial --HEAD`
        4. `brew cleanup mercurial`  # to remove the older non-HEAD version
      EOS
    end
  end

  test do
    system "#{bin}/hg", "debuginstall"
  end
end
