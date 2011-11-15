require 'formula'

class Mercurial < Formula
  url 'http://mercurial.selenic.com/release/mercurial-1.9.3.tar.gz'
  homepage 'http://mercurial.selenic.com/'
  md5 'f309b084aaf58773e9f4f4d66c49622a'

  def install
    # Don't add compiler specific flags so we can build against
    # System-provided Python.
    ENV.minimal_optimization

    # Force the binary install path to the Cellar
    inreplace "Makefile",
      "setup.py $(PURE) install",
      "setup.py $(PURE) install --install-scripts=\"#{libexec}\""

    # Make Mercurial into the Cellar.
    # Skip making the docs; depends on 'docutils' module.
    system "make", "PREFIX=#{prefix}", "build"
    system "make", "PREFIX=#{prefix}", "install-bin"

    # Now we have lib/python2.x/site-packages/ with Mercurial
    # libs in them. We want to move these out of site-packages into
    # a self-contained folder. Let's choose libexec.
    bin.mkpath
    libexec.mkpath

    libexec.install Dir["#{lib}/python*/site-packages/*"]

    # Symlink the hg binary into bin
    ln_s libexec+'hg', bin+'hg'

    # Remove the hard-coded python invocation from hg
    inreplace bin+'hg', %r[#!/.*/python], '#!/usr/bin/env python'

    # Install some contribs
    bin.install 'contrib/hgk'

    # Install man pages
    man1.install 'doc/hg.1'
    man5.install ['doc/hgignore.5', 'doc/hgrc.5']
  end
end
