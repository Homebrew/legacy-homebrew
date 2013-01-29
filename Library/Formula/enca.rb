require 'formula'

class Enca < Formula
  homepage 'http://freshmeat.net/projects/enca'
  url 'http://dl.cihar.com/enca/enca-1.13.tar.gz'
  sha1 'c6e25ea4f4cc53100bd6dacd62ea22e39151d067'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
