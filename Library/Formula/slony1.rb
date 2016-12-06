require 'formula'

class Slony1 < Formula
  homepage 'http://slony.info/'
  url 'http://slony.info/downloads/2.1/source/slony1-2.1.2.tar.bz2'
  sha1 '47449fbc742a25eefdab088ab650973416bccb53'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "slon", "-v"
  end
end
