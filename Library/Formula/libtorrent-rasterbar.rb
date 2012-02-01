require 'formula'

class LibtorrentRasterbar < Formula
  url 'http://libtorrent.googlecode.com/files/libtorrent-rasterbar-0.15.9.tar.gz'
  homepage 'http://www.rasterbar.com/products/libtorrent/'
  md5 '87eea591f6eb5da4f3af84aa6d753bc7'

  depends_on 'boost'
  depends_on 'boost-jam' => :build

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
