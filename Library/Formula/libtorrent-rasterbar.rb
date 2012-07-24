require 'formula'

class LibtorrentRasterbar < Formula
  homepage 'http://www.rasterbar.com/products/libtorrent/'
  url  'http://libtorrent.googlecode.com/files/libtorrent-rasterbar-0.16.2.tar.gz'
  sha1 '04da641d21d0867fc103f4f57ffd41b3fce19ead'

  depends_on 'boost'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-tests",
                          "--enable-examples",
                          "--enable-python-binding",
                          "--with-boost-python=boost_python-mt"
    system "make install"
  end
end
