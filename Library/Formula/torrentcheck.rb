require 'formula'

class Torrentcheck < Formula
  url 'http://sourceforge.net/projects/torrentcheck/files/torrentcheck-1.00.zip'
  homepage 'http://torrentcheck.sourceforge.net/'
  md5 'ba12ae767888837fe3e70fb025d554c2'

  def install
    inreplace "torrentcheck.c", "#include <malloc.h>", ""
    system "#{ENV.cc} #{ENV.cflags} torrentcheck.c sha1.c -o torrentcheck"
    bin.install 'torrentcheck'

  end

  def test
    system "torrentcheck"
  end
end
