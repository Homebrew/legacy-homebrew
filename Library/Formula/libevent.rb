require 'formula'

class Libevent <Formula
  url "http://www.monkey.org/~provos/libevent-1.4.14b-stable.tar.gz"
  homepage 'http://www.monkey.org/~provos/libevent/'
  md5 'a00e037e4d3f9e4fe9893e8a2d27918c'
  head 'git://levent.git.sourceforge.net/gitroot/levent/levent'

  def install
    fails_with_llvm "Undefined symbol '_current_base' reported during linking.", :build => 2326

    ENV.j1 # Needed for Mac Pro compilation
    system "./autogen.sh" if ARGV.build_head?
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
