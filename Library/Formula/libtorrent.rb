require 'formula'

class Libtorrent < Formula
  url 'http://libtorrent.rakshasa.no/downloads/libtorrent-0.13.0.tar.gz'
  homepage 'http://libtorrent.rakshasa.no/'
  md5 'd499178f72010d5067a77f41fa1a1505'

  depends_on 'pkg-config' => :build
  depends_on 'libsigc++'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--with-kqueue", "--enable-ipv6"
    system "make"
    system "make install"
  end
end
