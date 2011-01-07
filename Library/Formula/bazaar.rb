require 'formula'

class Bazaar <Formula
  url 'http://launchpadlibrarian.net/59616932/bzr-2.2.2.tar.gz'
  md5 'd1bfa2fd1aad282c423c78d62ebacb21'
  homepage 'http://bazaar-vcs.org/'

  def options
    [["--system", "Install using the OS X system Python."]]
  end

  def install
    if ARGV.include? "--system"
      ENV.prepend "PATH", "/System/Library/Frameworks/Python.framework/Versions/Current/bin", ":"
    else
      python_version = `python -c "import sys;print sys.version"`
      if python_version[0,4] == "2.7."
        opoo <<-EOS
Bazaar might not yet work with Python 2.7.
You can force an installation using the system Python by doing:
  brew install bazaar --system
EOS
      end
    end

    # Find the archs of the Python we are building against.
    # If the python includes PPC support, then don't use Intel-
    # specific compiler flags
    archs = archs_for_command("python")
    ENV.minimal_optimization if archs.include? :ppc64 or archs.include? :ppc7400

    # Make the manual before we install (mv) bzrlib
    system "make man1/bzr.1"
    man1.install gzip('man1/bzr.1')

    system "make"
    inreplace "bzr", "#! /usr/bin/env python", "#!/usr/bin/python" if ARGV.include? "--system"
    libexec.install ['bzr', 'bzrlib']

    bin.mkpath
    ln_s libexec+'bzr', bin+'bzr'
  end

  def caveats
    <<-EOS.undent
    We've built a "standalone" version of bazaar and installed its libraries to:
      #{libexec}

    We've specifically kept it out of your Python's "site-packages" folder.
    EOS
  end
end
