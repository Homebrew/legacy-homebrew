require 'formula'

class Libevent <Formula
  url "http://www.monkey.org/~provos/libevent-1.4.14b-stable.tar.gz"
  homepage 'http://www.monkey.org/~provos/libevent/'
  md5 'a00e037e4d3f9e4fe9893e8a2d27918c'
  head 'git://levent.git.sourceforge.net/gitroot/levent/levent'

  def install
    system "./autogen.sh" if ARGV.build_head?

    ENV.j1 # Needed for Mac Pro compilation
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
