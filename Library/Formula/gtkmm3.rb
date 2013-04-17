require 'formula'

class Gtkmm3 < Formula
  homepage 'http://www.gtkmm.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gtkmm/3.6/gtkmm-3.6.0.tar.xz'
  sha256 '888154d5c8acec083aa15e8dab68d977a393ade7257f0630becfa9a223fa2359'

  depends_on 'xz' => :build
  depends_on 'pkg-config' => :build
  depends_on 'glibmm'
  depends_on 'gtk+3'
  depends_on 'libsigc++'
  depends_on 'pangomm'
  depends_on 'atkmm'
  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
