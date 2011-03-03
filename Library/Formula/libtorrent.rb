require 'formula'

class Libtorrent <Formula
  url 'http://libtorrent.rakshasa.no/downloads/libtorrent-0.12.6.tar.gz'
  homepage 'http://libtorrent.rakshasa.no/'
  md5 '037499ed708aaf72988cee60e5a8d96b'

  depends_on 'pkg-config' => :build
  depends_on 'libsigc++'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--with-kqueue", "--enable-ipv6"
    system "make"
    system "make install"
  end
end
