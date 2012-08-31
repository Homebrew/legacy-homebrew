require 'formula'

class LibtorrentRasterbar < Formula
  homepage 'http://www.rasterbar.com/products/libtorrent/'
  url 'http://libtorrent.googlecode.com/files/libtorrent-rasterbar-0.16.3.tar.gz'
  sha1 '72788037bdf6a0a4796b4d74e543528cbfe9899b'

  depends_on 'boost'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
