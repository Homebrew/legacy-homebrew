require 'formula'

class Wiggle < Formula
  url 'http://neil.brown.name/wiggle/wiggle-0.8.tar.gz'
  homepage 'http://neil.brown.name/blog/20100324064620'
  md5 '17aae004f63791faa4ff1d0e7639131d'

  def install
    # Deal with OS X malloc vs stdlib
    inreplace "load.c", "#include	<malloc.h>", "#include <stdlib.h>"
    inreplace Dir["*.c"], /#include\s+<malloc\.h>/, ""

    # Avoid running tests
    system "make wiggle wiggle.man"

    # Manual install into Homebrew prefix
    bin.install "wiggle"
    man1.install "wiggle.1"
  end
end
