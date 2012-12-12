require 'formula'

class Enca < Formula
  url 'http://dl.cihar.com/enca/enca-1.13.tar.gz'
  homepage 'http://freshmeat.net/projects/enca'
  sha1 'c6e25ea4f4cc53100bd6dacd62ea22e39151d067'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
