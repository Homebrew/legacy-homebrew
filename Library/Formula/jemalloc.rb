require 'formula'

class Jemalloc < Formula
  url 'http://www.canonware.com/download/jemalloc/jemalloc-2.1.1.tar.bz2'
  homepage 'http://www.canonware.com/jemalloc/download.html'
  md5 'a10d04be00bac06ac27e6a1a4b2008f6'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make install"
  end
end
