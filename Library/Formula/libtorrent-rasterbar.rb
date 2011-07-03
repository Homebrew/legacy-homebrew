require 'formula'

class LibtorrentRasterbar < Formula
  url 'http://libtorrent.googlecode.com/files/libtorrent-rasterbar-0.15.6.tar.gz'
  homepage 'http://www.rasterbar.com/products/libtorrent/'
  md5 '53c64fe121c7fd0383f90dc653930f4a'

  depends_on 'boost'
  depends_on 'boost-jam'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
