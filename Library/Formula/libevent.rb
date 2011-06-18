require 'formula'

class Libevent < Formula
  url "http://monkey.org/~provos/libevent-2.0.12-stable.tar.gz"
  homepage 'http://www.monkey.org/~provos/libevent/'
  md5 '42986228baf95e325778ed328a93e070'
  head 'git://levent.git.sourceforge.net/gitroot/levent/levent'

  fails_with_llvm "Undefined symbol '_current_base' reported during linking.", :build => 2326

  def install
    ENV.j1 # Needed for Mac Pro compilation
    system "./autogen.sh" if ARGV.build_head?
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
