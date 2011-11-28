require 'formula'

class Bazaar < Formula
  url 'http://launchpad.net/bzr/2.4/2.4.2/+download/bzr-2.4.2.tar.gz'
  md5 'cfc06fddd348445c65a247c0b33a05db'
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

    # Find the arch for the Python we are building against.
    # We remove 'ppc' support, so we can pass Intel-optimized CFLAGS.
    if ARGV.include? "--system"
      python_cmd = "/usr/bin/python"
    else
      python_cmd = "python"
    end

    archs = archs_for_command(python_cmd)
    archs.remove_ppc!
    ENV['ARCHFLAGS'] = archs.as_arch_flags

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
