require 'formula'

class Libmpdclient <Formula
  url 'http://downloads.sourceforge.net/project/musicpd/libmpdclient/2.3/libmpdclient-2.3.tar.bz2'
  homepage 'http://mpd.wikia.com/wiki/ClientLib:libmpdclient'
  md5 'd14bad30c9c117aa6b211ad9f96cfbe0'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
