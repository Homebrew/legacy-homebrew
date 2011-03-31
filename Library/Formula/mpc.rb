require 'formula'

class Mpc < Formula
  url 'http://downloads.sourceforge.net/project/musicpd/mpc/0.20/mpc-0.20.tar.bz2'
  homepage 'http://mpd.wikia.com/wiki/Client:Mpc'
  md5 '24c81ad6afe6099e8d7a6826ef4b7105'

  depends_on 'pkg-config' => :build
  depends_on 'libmpdclient'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
