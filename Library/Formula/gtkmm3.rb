require 'formula'

class Gtkmm3 < Formula
  homepage 'http://www.gtkmm.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gtkmm/3.10/gtkmm-3.10.1.tar.xz'
  sha256 '6fa5cdaa5cf386ea7c77fafed47e913afadd48fe45e28d8cb01075c3ee412538'

  depends_on 'pkg-config' => :build
  depends_on 'glibmm'
  depends_on 'gtk+3'
  depends_on 'libsigc++'
  depends_on 'pangomm'
  depends_on 'atkmm'
  depends_on 'cairomm'
  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
