require 'formula'

class Mercurial < Formula
  homepage 'http://mercurial.selenic.com/'
  url 'http://mercurial.selenic.com/release/mercurial-2.2.tar.gz'
  sha1 '8d2dc0b72d0e2aef70770a9eca32154f456e8afa'

  head 'http://selenic.com/repo/hg', :using => :hg

  depends_on 'docutils' => :python if ARGV.build_head? or ARGV.include? "--doc"

  def options
    [["--doc", "build the documentation. Depends on 'docutils' module."]]
  end

  def install
    # Don't add compiler specific flags so we can build against
    # System-provided Python.
    ENV.minimal_optimization

    # install the completion script
    (prefix + 'etc/bash_completion.d').install 'contrib/bash_completion' => 'hg-completion.bash'

    # Force the binary install path to the Cellar
    inreplace "Makefile",
      "setup.py $(PURE) install",
      "setup.py $(PURE) install --install-scripts=\"#{libexec}\""

    # Make Mercurial into the Cellar.
    # The documentation must be built when using HEAD
    system "make", "doc" if ARGV.build_head? or ARGV.include? "--doc"
    system "make", "PREFIX=#{prefix}", "build"
    system "make", "PREFIX=#{prefix}", "install-bin"

    # Now we have lib/python2.x/site-packages/ with Mercurial
    # libs in them. We want to move these out of site-packages into
    # a self-contained folder. Let's choose libexec.
    libexec.install Dir["#{lib}/python*/site-packages/*"]

    # Symlink the hg binary into bin
    bin.install_symlink libexec+'hg'

    # Remove the hard-coded python invocation from hg
    inreplace bin+'hg', %r[#!/.*/python(/.*)?], '#!/usr/bin/env python'

    # Install some contribs
    bin.install 'contrib/hgk'

    # Install man pages
    man1.install 'doc/hg.1'
    man5.install 'doc/hgignore.5', 'doc/hgrc.5'
  end

  def caveats
    if ARGV.build_head? then <<-EOS.undent
      Mercurial is required to fetch its own repository, so there are now two
      installations of mercurial on this machine. If the previous installation
      was done via Homebrew, the old version may need to be cleaned up and new
      version linked:

          brew cleanup mercurial && brew link mercurial
      EOS
    end
  end

  def test
    system "#{bin}/hg", "debuginstall"
  end
end
