require 'formula'

class Mpc < Formula
  homepage 'http://mpd.wikia.com/wiki/Client:Mpc'
  url 'http://sourceforge.net/projects/musicpd/files/mpc/0.22/mpc-0.22.tar.bz2'
  sha1 '62f541251f137f87f3a5dbdcaa171f8741b47f72'

  depends_on 'pkg-config' => :build
  depends_on 'libmpdclient'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
