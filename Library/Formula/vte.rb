require 'formula'

class Vte < Formula
  url 'http://ftp.gnome.org/pub/gnome/sources/vte/0.28/vte-0.28.0.tar.bz2'
  homepage 'http://developer.gnome.org/vte/'
  md5 'c21e08e973a47a9d105c24506e537848'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'gtk+'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-python",
                          "--disable-Bsymbolic"
    system "make install"
  end
end
