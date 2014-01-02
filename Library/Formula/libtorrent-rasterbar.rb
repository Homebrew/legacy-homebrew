require 'formula'

class LibtorrentRasterbar < Formula
  homepage 'http://www.rasterbar.com/products/libtorrent/'
  url 'https://libtorrent.googlecode.com/files/libtorrent-rasterbar-0.16.13.tar.gz'
  sha1 '93a2098d77e9f36ff99966311be1e6cbb131e70f'

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
