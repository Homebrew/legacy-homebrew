require 'formula'

class GnupgInstalled < Requirement
  def message; <<-EOS.undent
    Gnupg is required to use these tools.

    You can install Gnupg or Gnupg2 with Homebrew:
      brew install gnupg
      brew install gnupg2

    Or you can use one of several different
    prepackaged installers that are available.
    EOS
  end

  def satisfied?
    which 'gpg' or which 'gpg2'
  end

  def fatal?
    false
  end
end

class ZeroinstallInjector < Formula
  homepage 'http://0install.net/injector.html'
  url 'http://downloads.sourceforge.net/project/zero-install/injector/1.11/zeroinstall-injector-1.11.tar.bz2'
  sha256 'a1a9e79b32dcdbc095dbe4901a9c4115d2949b530f6a16aed1c58579d18c9c95'

  head 'http://repo.or.cz/r/zeroinstall.git'

  option 'without-gui', "Build without the gui (requires GTK+)"

  depends_on GnupgInstalled.new
  depends_on 'pygobject' if build.include? 'without-gui'
  depends_on 'pygtk' unless build.include? 'without-gui'
  depends_on 'gettext' if build.head?

  def install
    inreplace 'setup.py', "man/man1", "share/man/man1"
    system "make", "translations" if build.head?
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end

  def caveats; <<-EOS.undent
    For non-Homebrew Python, you need to amend your PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH
    EOS
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end
