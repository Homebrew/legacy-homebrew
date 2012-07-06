require 'formula'

class Jemalloc < Formula
  homepage 'http://www.canonware.com/jemalloc/download.html'
  url 'http://www.canonware.com/download/jemalloc/jemalloc-3.0.0.tar.bz2'
  sha1 '65a66bd1b54ffdd56f5024b45df19d40d6e6f9dd'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make install"
  end
end
