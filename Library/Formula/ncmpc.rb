require 'formula'

class Ncmpc < Formula
  url 'http://downloads.sourceforge.net/musicpd/ncmpc-0.19.tar.bz2'
  homepage 'http://mpd.wikia.com/wiki/Client:Ncmpc'
  md5 'd298ad1313ef3a522ef03367f8a1ffc0'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'libmpdclient'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
