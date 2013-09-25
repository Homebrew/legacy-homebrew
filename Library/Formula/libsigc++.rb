require 'formula'

class Libsigcxx < Formula
  homepage 'http://libsigc.sourceforge.net'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.2/libsigc++-2.2.11.tar.xz'
  sha256 '9834045f74f56752c2c6b3cdc195c30ab8314ad22dc8e626d6f67f940f1e4957'

  depends_on 'xz' => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make check"
    system "make install"
  end
end
