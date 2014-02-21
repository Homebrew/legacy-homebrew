require 'formula'

class LibtorrentRasterbar < Formula
  homepage 'http://www.rasterbar.com/products/libtorrent/'
  url 'http://downloads.sourceforge.net/project/libtorrent/libtorrent/libtorrent-rasterbar-0.16.14.tar.gz'
  sha1 'e9075354af9b7c3f6a62d54d34c407c75b0bfaff'

  depends_on 'pkg-config' => :build
  depends_on 'boost'
  depends_on 'openssl' if MacOS.version <= :snow_leopard # Needs a newer version of OpenSSL on Snow Leopard

  def install
    boost = Formula.factory('boost')
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{boost.opt_prefix}"
    system "make install"
  end
end
