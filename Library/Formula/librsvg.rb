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
    # Fixes gtk-2.0.pc finding cairo.pc in /opt/X11 on 10.8
    # https://github.com/mxcl/homebrew/issues/14474
    if MacOS.mountain_lion?
      cairo = Formula.factory('cairo')
      ENV.prepend 'PKG_CONFIG_PATH', "#{cairo.lib}/pkgconfig", ':'
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-Bsymbolic",
                          "--enable-tools=yes",
                          "--enable-pixbuf-loader=yes",
                          "--enable-introspection=no"
    system "make install"
  end
end
