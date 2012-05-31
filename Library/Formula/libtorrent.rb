require 'formula'

class Libtorrent < Formula
  homepage 'http://libtorrent.rakshasa.no/'
  url 'http://libtorrent.rakshasa.no/downloads/libtorrent-0.12.9.tar.gz'
  md5 'b128bbd324f03eb42ef5060080f87548'

  depends_on 'pkg-config' => :build
  depends_on 'libsigc++'

  # Upstream says this is fixed in 0.13.x series, so check if this is
  # still needed when the next stable libtorrent release is made.
  fails_with :clang do
    build 318
  end

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
