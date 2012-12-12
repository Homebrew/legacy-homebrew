require 'formula'

class LibtorrentRasterbar < Formula
  homepage 'http://www.rasterbar.com/products/libtorrent/'
  url 'http://libtorrent.googlecode.com/files/libtorrent-rasterbar-0.16.5.tar.gz'
  sha1 'dde29c7a51392d9098de23e2e69a993a5c380016'

  depends_on 'boost'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
