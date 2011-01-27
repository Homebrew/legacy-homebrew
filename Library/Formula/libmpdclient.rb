require 'formula'

class Libmpdclient <Formula
  url 'http://downloads.sourceforge.net/project/musicpd/libmpdclient/2.1/libmpdclient-2.1.tar.bz2'
  homepage 'http://mpd.wikia.com/wiki/ClientLib:libmpdclient'
  md5 '67efa0c3d107c090ef277dfb3442d1e3'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
