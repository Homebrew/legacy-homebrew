class Bazaar < Formula
  desc "Human-friendly source code management (or 'version control')"
  homepage "http://bazaar.canonical.com/"
  url "https://launchpad.net/bzr/2.6/2.6.0/+download/bzr-2.6.0.tar.gz"
  sha256 "0994797182eb828867eee81cccc79480bd2946c99304266bc427b902cf91dab0"

  bottle do
    cellar :any
    sha1 "13eb87ddde4c81d02a54ba014712fa5d152b3f3c" => :yosemite
    sha1 "79a3661c5a85e6041cbabb12fb237263dee1eaa9" => :mavericks
    sha1 "d13db375fa4c2edf0119ffefbb995e4da59c7681" => :mountain_lion
  end

  def install
    ENV.j1 # Builds aren't parallel-safe

    # Make and install man page first
    system "make", "man1/bzr.1"
    man1.install "man1/bzr.1"

    # Put system Python first in path
    ENV.prepend_path "PATH", "/System/Library/Frameworks/Python.framework/Versions/Current/bin"

    system "make"
    inreplace "bzr", "#! /usr/bin/env python", "#!/usr/bin/python"
    libexec.install "bzr", "bzrlib"

    bin.install_symlink libexec+"bzr"
  end

  test do
    system bin/"bzr", "init-repo", "test"
  end
end
