require 'formula'

class Mdf2iso < Formula
  homepage 'http://mdf2iso.berlios.de/'
  url 'http://download.berlios.de/mdf2iso/mdf2iso-0.3.0-src.tar.bz2'
  sha1 'd424bd84a2c45834d7b7060306aa9ee1926c9215'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
