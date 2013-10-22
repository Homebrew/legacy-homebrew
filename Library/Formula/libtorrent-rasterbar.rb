require 'formula'

class LibtorrentRasterbar < Formula
  homepage 'http://www.rasterbar.com/products/libtorrent/'
  url 'https://libtorrent.googlecode.com/files/libtorrent-rasterbar-0.16.11.tar.gz'
  sha1 'accf70b2ddc5ab048a35c6dc3ef20718a67833f5'

  depends_on 'pkg-config' => :build
  depends_on 'boost'
  depends_on 'openssl' if MacOS.version <= :snow_leopard # Needs a newer version of OpenSSL on Snow Leopard

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
