require 'formula'

class Glade < Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/glade3/3.8/glade3-3.8.0.tar.bz2'
  homepage 'http://glade.gnome.org/'
  md5 '42f8b2dd01b9bfb8860bb3a5d978e1a2'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'intltool'
  depends_on 'libglade'
  depends_on 'hicolor-icon-theme'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
