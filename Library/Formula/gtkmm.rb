require 'formula'

class Gtkmm < Formula
  homepage 'http://www.gtkmm.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gtkmm/2.24/gtkmm-2.24.3.tar.xz'
  sha256 'c564a438677174b97d69dd70467cb03c933481006398dc9377417aa6abe02a39'

  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'atkmm'
  depends_on 'cairomm'
  depends_on 'glibmm'
  depends_on 'gtk+'
  depends_on 'libsigc++'
  depends_on 'pangomm'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
