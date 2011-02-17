require 'formula'

class Libevent <Formula
  url "http://downloads.sourceforge.net/project/levent/libevent/libevent-2.0/libevent-2.0.10-stable.tar.gz"
  homepage 'http://www.monkey.org/~provos/libevent/'
  md5 'a37401d26cbbf28185211d582741a3d4'
  head 'git://levent.git.sourceforge.net/gitroot/levent/levent'

  def install
    fails_with_llvm "Undefined symbol '_current_base' reported during linking.", :build => 2326

    ENV.j1 # Needed for Mac Pro compilation
    system "./autogen.sh" if ARGV.build_head?
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
