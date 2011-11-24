require 'formula'

class Jemalloc < Formula
  url 'http://www.canonware.com/download/jemalloc/jemalloc-2.2.2.tar.bz2'
  homepage 'http://www.canonware.com/jemalloc/download.html'
  md5 '65b2b3f68c9d229246a67f5a4d29ba83'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make install"
  end
end
