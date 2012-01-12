require 'formula'

class Libevent < Formula
  url "https://github.com/downloads/libevent/libevent/libevent-2.0.16-stable.tar.gz"
  homepage 'http://www.monkey.org/~provos/libevent/'
  sha1 '9eb9fe3c0ec607525ed2dee6827687efcd0696ac'
  head 'git://levent.git.sourceforge.net/gitroot/levent/levent'

  fails_with_llvm "Undefined symbol '_current_base' reported during linking.", :build => 2326

  def install
    ENV.j1 # Needed for Mac Pro compilation
    system "./autogen.sh" if ARGV.build_head?
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
