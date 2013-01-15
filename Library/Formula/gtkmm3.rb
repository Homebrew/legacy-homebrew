require 'formula'

class Gtkmm3 < Formula
  homepage 'http://www.gtkmm.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gtkmm/3.4/gtkmm-3.4.2.tar.xz'
  sha256 '760c01bca693d26558eb5eae0cf6c743a6bb453258a633f78de506e3c98262b4'

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
