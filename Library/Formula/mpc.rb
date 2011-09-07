require 'formula'

class Mpc < Formula
  url 'http://downloads.sourceforge.net/project/musicpd/mpc/0.21/mpc-0.21.tar.bz2'
  homepage 'http://mpd.wikia.com/wiki/Client:Mpc'
  md5 'd8f88aad5fa7ed4c6e7005c5ec1ba7c5'

  depends_on 'pkg-config' => :build
  depends_on 'libmpdclient'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
