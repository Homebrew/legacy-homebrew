require 'formula'

class Libmpdclient < Formula
  homepage 'http://mpd.wikia.com/wiki/ClientLib:libmpdclient'
  url 'http://downloads.sourceforge.net/project/musicpd/libmpdclient/2.7/libmpdclient-2.7.tar.bz2'
  sha1 'a8ec78f6a7ae051fbf1cc0f47564301423c281b0'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
