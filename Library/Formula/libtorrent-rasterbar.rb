require 'formula'

class LibtorrentRasterbar < Formula
  homepage 'http://www.rasterbar.com/products/libtorrent/'
  url 'https://libtorrent.googlecode.com/files/libtorrent-rasterbar-0.16.10.tar.gz'
  sha1 '8b24442132e52f8765c79b20ffdea8b33bc5aa42'

  depends_on 'boost'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
