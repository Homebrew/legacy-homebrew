require 'formula'

class Libgsf <Formula
  url 'http://ftp.acc.umu.se/pub/GNOME/sources/libgsf/1.14/libgsf-1.14.17.tar.bz2'
  homepage 'http://directory.fsf.org/project/libgsf/'
  sha256 '10c6b69149e424ac5f325eb247fdf640ddd949952f21b99a890e73f9d4276876'

  depends_on 'pkg-config'
  depends_on 'gettext'
  depends_on 'intltool'
  depends_on 'glib'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
