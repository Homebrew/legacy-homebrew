require 'formula'

class Mercurial < Formula
  homepage 'http://mercurial.selenic.com/'
  url 'http://mercurial.selenic.com/release/mercurial-2.6.1.tar.gz'
  sha1 'ee9b2ae1cf2518c90b55f9429bf4ed9f2d4fced6'

  head 'http://selenic.com/repo/hg', :using => :hg

  depends_on :python # its written in Python, so this is a hard dep
  depends_on 'docutils' => :python

  def install
    python do
      # Inside this python do block, the PYTHONPATH (and more) is alreay set up
      if python.from_osx? && !MacOS::CLT.installed?
        # Help castrated system python on Xcode find the Python.h:
        # Setting CFLAGS does not work :-(
        inreplace 'setup.py', 'get_python_inc()', "'#{python.incdir}'"
      end

      # Man pages come pre-built in source releases
      system "make doc"
      system "make", "PREFIX=#{prefix}", "install"

      # Install some contribs
      bin.install "contrib/hgk"
      # Install man pages
      man1.install 'doc/hg.1'
      man5.install 'doc/hgignore.5', 'doc/hgrc.5'
    end

    # install the completion scripts
    bash_completion.install 'contrib/bash_completion' => 'hg-completion.bash'
    zsh_completion.install 'contrib/zsh_completion' => '_hg'
  end

  def caveats
    s = <<-EOS.undent
      In order to use the graphical `hgk`, you may have to set:
        export HG=hg
      and add to your ~/.hgrc file:
        [extensions]
        hgk=
    EOS

    if build.head? then s += <<-EOS.undent
        To install the --HEAD version of mercurial, you have to:
          1. `brew install mercurial`  # so brew can use this to fetch sources!
          2. `brew unlink mercurial`
          3. `brew install mercurial --HEAD`
          4. `brew cleanup mercurial`  # to remove the older non-HEAD version
      EOS
    end
    s += python.standard_caveats if python
    s
  end

  def test
    system "#{bin}/hg", "debuginstall"
  end
end
