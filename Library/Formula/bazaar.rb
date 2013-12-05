require 'formula'

class Bazaar < Formula
  homepage 'http://bazaar-vcs.org/'
  url 'https://launchpad.net/bzr/2.6/2.6.0/+download/bzr-2.6.0.tar.gz'
  sha1 '5eb4d0367c6d83396250165da5bb2c8a9f378293'

  option "system", "Install using the OS X system Python."

  def install
    ENV.j1 # Builds aren't parallel-safe

    # Make and install man page first
    system "make man1/bzr.1"
    man1.install "man1/bzr.1"

    if build.include? "system"
      ENV.prepend "PATH", "/System/Library/Frameworks/Python.framework/Versions/Current/bin", ":"
    end

    system "make"
    inreplace "bzr", "#! /usr/bin/env python", "#!/usr/bin/python" if build.include? "system"
    libexec.install 'bzr', 'bzrlib'

    bin.install_symlink libexec+'bzr'
  end
end
