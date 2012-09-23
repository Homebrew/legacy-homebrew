require 'formula'

class Glibmm < Formula
  homepage 'http://www.gtkmm.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/glibmm/2.32/glibmm-2.32.0.tar.xz'
  sha256 'e1806f884c6e9f904ee2af0d39dd8d4de3f91a039f897f54333b0890de06f94b'

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
