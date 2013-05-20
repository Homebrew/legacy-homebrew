require 'formula'

class Glibmm < Formula
  homepage 'http://www.gtkmm.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/glibmm/2.36/glibmm-2.36.2.tar.xz'
  sha256 'f15b65bf5740257be03c69f2f5ae71436ac3011ebeb02274b2b99b796c6837cf'

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
