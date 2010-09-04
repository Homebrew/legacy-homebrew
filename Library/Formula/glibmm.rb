require 'formula'

class Glibmm <Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/glibmm/2.22/glibmm-2.22.2.tar.gz'
  homepage 'http://www.gtkmm.org/'
  md5 '90ff0a5bd5987431cf36f0aa0160a753'

  depends_on 'pkg-config'
  depends_on 'libsigc++'
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
