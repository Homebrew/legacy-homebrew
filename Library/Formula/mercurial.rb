require 'formula'

class Mercurial < Formula
  homepage 'http://mercurial.selenic.com/'
  url 'http://mercurial.selenic.com/release/mercurial-2.4.2.tar.gz'
  sha1 'ade387c4c907abff235e887a9b4678450363c756'

  head 'http://selenic.com/repo/hg', :using => :hg

  depends_on 'docutils' => :python if build.head? or build.include? 'doc'

  option 'doc', "Build the documentation"

  def install
    # "Don't add compiler specific flags so we can build against System-provided
    # Python." - this is actually not needed on ML, not sure about earlier versions.
    ENV.minimal_optimization unless MacOS.version >= :mountain_lion
    ENV.j1

    system "make", "PREFIX=#{prefix}", "install-bin"

    # Man pages come pre-built in source releases
    system "make doc" if build.head? or build.include? 'doc'
	
    # Install man pages
    man1.install 'doc/hg.1'
    man5.install 'doc/hgignore.5', 'doc/hgrc.5'

    # Remove the hard-coded python invocation from hg
    inreplace bin/'hg', %r[^#!.*$], '#!/usr/bin/env python'

    # Install some contribs
    bin.install 'contrib/hgk'
    (prefix/'etc/bash_completion.d').install 'contrib/bash_completion' => 'hg-completion.bash'
  end

  def caveats
    s = ''

    if build.head? then s += <<-EOS.undent

      Mercurial is required to fetch its own repository, so there are now two
      installations of mercurial on this machine. If the previous installation
      was done via Homebrew, the old version may need to be cleaned up and new
      version linked:

        brew cleanup mercurial && brew link mercurial
      EOS
    end

    return s
  end

  def test
    system "#{bin}/hg", "debuginstall"
  end
end
