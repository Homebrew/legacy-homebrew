require 'formula'

class Libtorrent < Formula
  homepage 'http://libtorrent.rakshasa.no/'
  url 'http://libtorrent.rakshasa.no/downloads/libtorrent-0.13.2.tar.gz'
  md5 '96c0b81501357df402ab592f59ecaeab'

  depends_on 'pkg-config' => :build
  depends_on 'libsigc++'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-kqueue",
                          "--enable-ipv6"
    system "make"
    system "make install"
  end
end
