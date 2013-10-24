require 'formula'

class Gtkmm3 < Formula
  homepage 'http://www.gtkmm.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gtkmm/3.10/gtkmm-3.10.0.tar.xz'
  sha256 '5e45fed4a7cff1baa72d1ef67e0d9883063d3a575cb53190e7ecf27047d241f8'

  depends_on 'xz' => :build
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
