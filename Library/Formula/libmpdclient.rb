require 'formula'

class Libmpdclient < Formula
  url 'http://downloads.sourceforge.net/project/musicpd/libmpdclient/2.5/libmpdclient-2.5.tar.bz2'
  homepage 'http://mpd.wikia.com/wiki/ClientLib:libmpdclient'
  sha1 '4e3c0925c92c27ddcb13113adc7ebe6dc975abc6'

  def options
    [[ '--universal', 'Build a universal library.' ]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
