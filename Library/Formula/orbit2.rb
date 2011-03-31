require 'formula'

class Orbit2 < Formula
  url 'ftp://ftp.gnome.org/pub/gnome/sources/ORBit2/2.14/ORBit2-2.14.19.tar.gz'
  homepage 'http://projects.gnome.org/ORBit2'
  md5 '87c69c56c6d0bdafa4de5e18ae115cc9'

  depends_on "libidl"
  depends_on "popt"
  depends_on "linc"
  depends_on "gnome-common"

  def install
    ENV["LIBS"] = "-lresolv"
    system "./configure --prefix=#{prefix}"
    system "make install"
  end
end
