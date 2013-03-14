require 'formula'

class Mercurial < Formula
  homepage 'http://mercurial.selenic.com/'
  url 'http://mercurial.selenic.com/release/mercurial-2.5.2.tar.gz'
  sha1 'aa1503c353370bafc90d79b9c682aae9c1001c3c'

  head 'http://selenic.com/repo/hg', :using => :hg

  depends_on 'docutils' => :python if build.head? or build.include? 'doc'

  option 'doc', "Build the documentation"

  def install
    # Don't add compiler specific flags so we can build against
    # System-provided Python.
    ENV.minimal_optimization

    # install the completion script
    (prefix/'etc/bash_completion.d').install 'contrib/bash_completion' => 'hg-completion.bash'

    system "make doc" if build.head? or build.include? 'doc'
    system "make local"

    libexec.install 'hg', 'mercurial', 'hgext'

    # Symlink the hg binary into bin
    bin.install_symlink libexec/'hg'

    # Remove the hard-coded python invocation from hg
    inreplace bin/'hg', %r[^#!.*$], '#!/usr/bin/env python'

    # Install some contribs
    bin.install 'contrib/hgk'

    # Install man pages
    man1.install 'doc/hg.1'
    man5.install 'doc/hgignore.5', 'doc/hgrc.5'
  end

  def caveats
    s = ''

    s += <<-EOS.undent
      Extensions have been installed to:
        #{opt_prefix}/libexec/hgext
    EOS

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
