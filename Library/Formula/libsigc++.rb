require 'formula'

class Libsigcxx < Formula
  homepage 'http://libsigc.sourceforge.net'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.2/libsigc++-2.2.9.tar.bz2'
  sha256 '2f4c083e01d9be377669206bd97090d2e95bc05f2e8d95447c9f9ce92bdfbb63'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end
