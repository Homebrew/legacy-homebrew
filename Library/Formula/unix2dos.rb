require 'formula'

class Unix2dos < Formula
  url 'http://trac.macports.org/export/31021/distfiles/unix2dos/unix2dos-2.2.src.tar.gz'
  md5 'caf9f33155073d3efd310eff9103170b'
  homepage 'http://en.wikipedia.org/wiki/Unix2dos'

  def install
    # Don't use the Makefile as it doesn't optimize
    system "#{ENV.cc} #{ENV.cflags} unix2dos.c -o unix2dos"
    bin.install "unix2dos"
    man1.install "unix2dos.1"
  end
end
