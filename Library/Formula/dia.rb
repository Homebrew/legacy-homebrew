require 'formula'

class Dia < Formula
  homepage 'http://live.gnome.org/Dia'
  url 'http://ftp.gnome.org/pub/gnome/sources/dia/0.97/dia-0.97.2.tar.xz'
  sha256 'a761478fb98697f71b00d3041d7c267f3db4b94fe33ac07c689cb89c4fe5eae1'

  depends_on 'pkg-config' => :build
  depends_on 'intltool'
  depends_on 'gettext'
  depends_on 'pango'
  depends_on 'libtiff'
  depends_on 'gtk+'

  def install
    ENV.x11
    # fix for Leopard, potentially others with isspecial defined elswhere
    inreplace 'objects/GRAFCET/boolequation.c', 'isspecial', 'char_isspecial'
    system "./configure", "--enable-debug=no",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    rm_rf share+"applications"
  end
end
