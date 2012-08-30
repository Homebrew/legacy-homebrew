require 'formula'

class Librsvg < Formula
  homepage 'https://live.gnome.org/LibRsvg'
  url 'http://ftp.gnome.org/pub/GNOME/sources/librsvg/2.36/librsvg-2.36.1.tar.xz'
  sha256 '786b95e1a091375c5ef2997a21c69ff24d7077afeff18197355f54d9dcbcd8c5'

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
