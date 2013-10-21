require 'formula'

class Libsigcxx < Formula
  homepage 'http://libsigc.sourceforge.net'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.3/libsigc++-2.3.1.tar.xz'
  sha256 '67d05852b31fdb267c9fdcecd40b046a11aa54d884435e99e3c60dd20cd60393'

  depends_on 'xz' => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make check"
    system "make install"
  end
end
