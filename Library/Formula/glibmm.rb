require 'formula'

class Glibmm < Formula
  homepage 'http://www.gtkmm.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/glibmm/2.34/glibmm-2.34.1.tar.xz'
  sha256 'b425a52c7e178aeaaaffd02c5497bfd68d0cb8be56cef3620558a80dd5d692c4'

  depends_on 'xz' => :build
  depends_on 'pkg-config' => :build
  depends_on 'libsigc++'
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
