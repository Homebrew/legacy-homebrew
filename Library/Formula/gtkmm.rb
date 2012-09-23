require 'formula'

class Gtkmm < Formula
  homepage 'http://www.gtkmm.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gtkmm/2.24/gtkmm-2.24.2.tar.bz2'
  sha256 '771a69c3252d06b20d4e8be4822bd7fa3b58424458733e3526218a128f1fea34'

  depends_on 'pkg-config' => :build
  depends_on 'glibmm'
  depends_on 'gtk+'
  depends_on 'libsigc++'
  depends_on 'pangomm'
  depends_on 'atkmm'
  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
