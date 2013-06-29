require 'formula'

class Libtorrent < Formula
  homepage 'http://libtorrent.rakshasa.no/'
  url 'http://libtorrent.rakshasa.no/downloads/libtorrent-0.13.3.tar.gz'
  sha256 '34317d6783b7f8d0805274c9467475b5432a246c0de8e28fc16e3b0b43f35677'

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
