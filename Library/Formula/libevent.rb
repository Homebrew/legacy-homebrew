require 'formula'

class Libevent <Formula
  version '2.0.10'
  url 'http://sourceforge.net/projects/levent/files/libevent/libevent-2.0/libevent-2.0.10-stable.tar.gz/download'
  homepage 'http://www.monkey.org/~provos/libevent/'
  md5 'a37401d26cbbf28185211d582741a3d4'
  head 'git://levent.git.sourceforge.net/gitroot/levent/levent'

  def install
    ENV.j1 # Needed for Mac Pro compilation
    system "./autogen.sh" if ARGV.build_head?
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
