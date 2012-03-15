require 'formula'

class Libsigcxx < Formula
  homepage 'http://libsigc.sourceforge.net'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.2/libsigc++-2.2.10.tar.bz2'
  sha256 'd3d810c2ad469edfb2d4db29643bef189b7613019eadbd4a72823af3c73c959c'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make check"
    system "make install"
  end
end
