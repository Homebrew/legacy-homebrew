require 'formula'

class Libmpdclient <Formula
  url 'http://downloads.sourceforge.net/project/musicpd/libmpdclient/2.4/libmpdclient-2.4.tar.bz2'
  homepage 'http://mpd.wikia.com/wiki/ClientLib:libmpdclient'
  md5 '8c166c5212dd95d538d3a35bb9ad4634'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
