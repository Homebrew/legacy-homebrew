require 'formula'

class Librsvg < Formula
  homepage 'https://live.gnome.org/LibRsvg'
  url 'http://ftp.gnome.org/pub/GNOME/sources/librsvg/2.36/librsvg-2.36.3.tar.xz'
  sha256 '3d7d583271030e21acacc60cb6b81ee305713c9da5e98429cbd609312aea3632'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'gtk+'
  depends_on 'libcroco'
  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-Bsymbolic",
                          "--enable-tools=yes",
                          "--enable-pixbuf-loader=yes",
                          "--enable-introspection=no"
    system "make install"
  end
end
