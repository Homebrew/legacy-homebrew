require 'formula'

class Bazaar <Formula
  url 'http://launchpad.net/bzr/2.3/2.3.0/+download/bzr-2.3.0.tar.gz'
  md5 '2d8bc55d43209189a209361178d9d372'
  homepage 'http://bazaar-vcs.org/'

  def options
    [["--system", "Install using the OS X system Python."]]
  end

  def install
    ENV.j1 # Builds aren't parallel-safe

    # Make and install man page first
    system "make man1/bzr.1"
    man1.install "man1/bzr.1"

    if ARGV.include? "--system"
      ENV.prepend "PATH", "/System/Library/Frameworks/Python.framework/Versions/Current/bin", ":"
    end

    # Find the archs of the Python we are building against.
    # If the python includes PPC support, then don't use Intel-
    # specific compiler flags
    archs = archs_for_command("python")
    ENV.minimal_optimization if archs.include? :ppc64 or archs.include? :ppc7400

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
