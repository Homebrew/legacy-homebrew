require 'formula'

class Libmpdclient < Formula
  url 'http://downloads.sourceforge.net/project/musicpd/libmpdclient/2.7/libmpdclient-2.7.tar.bz2'
  homepage 'http://mpd.wikia.com/wiki/ClientLib:libmpdclient'
  sha1 'a8ec78f6a7ae051fbf1cc0f47564301423c281b0'

  def options
    [[ '--universal', 'Build a universal library.' ]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
