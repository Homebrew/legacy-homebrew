require 'formula'

class Libtorrent < Formula
  homepage 'http://libtorrent.rakshasa.no/'
  url 'http://libtorrent.rakshasa.no/downloads/libtorrent-0.13.2.tar.gz'
  sha1 '4f34a744fbe10c54aaf53d34681fabc1a49d7257'

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
