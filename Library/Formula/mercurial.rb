require 'formula'

class Mercurial < Formula
  homepage 'http://mercurial.selenic.com/'
  url 'http://mercurial.selenic.com/release/mercurial-2.6.3.tar.gz'
  sha1 'd42f6021c1f45e9cf761f07b6d34c8a7e45a4c8d'

  head 'http://selenic.com/repo/hg', :using => :hg

  option 'enable-docs', "Build the docs (and require docutils)"

  depends_on :python
  depends_on :python => 'docutils' if build.include? 'enable-docs'

  def install
    ENV.minimal_optimization if MacOS.version <= :snow_leopard
    python do
      # Inside this python do block, the PYTHONPATH (and more) is alreay set up
      if python.from_osx? && !MacOS::CLT.installed?
        # Help castrated system python on Xcode find the Python.h:
        # Setting CFLAGS does not work :-(
        inreplace 'setup.py', 'get_python_inc()', "'#{python.incdir}'"
      end

      if build.include? 'enable-doc'
        system "make", "doc", "PREFIX=#{prefix}"
        system "make", "install-doc", "PREFIX=#{prefix}"
      end

      system "make", "PREFIX=#{prefix}", "install-bin"
      # Install man pages, which come pre-built in source releases
      man1.install 'doc/hg.1'
      man5.install 'doc/hgignore.5', 'doc/hgrc.5'
    end

    # install the completion scripts
    bash_completion.install 'contrib/bash_completion' => 'hg-completion.bash'
    zsh_completion.install 'contrib/zsh_completion' => '_hg'
  end

  def caveats
    s = ''
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

  test do
    system "#{bin}/hg", "debuginstall"
  end
end
