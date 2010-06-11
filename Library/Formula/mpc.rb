require 'formula'

class Mpc <Formula
  url 'http://downloads.sourceforge.net/project/musicpd/mpc/0.19/mpc-0.19.tar.bz2'
  homepage 'http://mpd.wikia.com/wiki/Client:Mpc'
  md5 '9ab2967d9ec719b06a86f3b4121be654'

  depends_on 'pkg-config'
  depends_on 'libmpdclient'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
