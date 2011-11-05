require 'formula'

class Libtorrent < Formula
  url 'http://libtorrent.rakshasa.no/downloads/libtorrent-0.12.9.tar.gz'
  homepage 'http://libtorrent.rakshasa.no/'
  md5 'b128bbd324f03eb42ef5060080f87548'

  depends_on 'pkg-config' => :build
  depends_on 'libsigc++'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--with-kqueue", "--enable-ipv6"
    system "make"
    system "make install"
  end
end
