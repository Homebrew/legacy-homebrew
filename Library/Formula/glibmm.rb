require 'formula'

class Glibmm < Formula
  homepage 'http://www.gtkmm.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/glibmm/2.36/glibmm-2.36.0.tar.xz'
  sha256 '59c54996cccc527f3a257964e7226151175c423f6fb22166e81d65a652f483f3'

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
