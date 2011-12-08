require 'formula'

class Libmpdclient < Formula
  url 'http://downloads.sourceforge.net/project/musicpd/libmpdclient/2.6/libmpdclient-2.6.tar.bz2'
  homepage 'http://mpd.wikia.com/wiki/ClientLib:libmpdclient'
  sha1 '00d88152c0e8599f56d01625da41b55d3a43c264'

  def options
    [[ '--universal', 'Build a universal library.' ]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
