require 'formula'

class Libgnomecanvasmm < Formula
  homepage 'https://launchpad.net/libgnomecanvasmm'
  url 'http://ftp.gnome.org/pub/gnome/sources/libgnomecanvasmm/2.26/libgnomecanvasmm-2.26.0.tar.bz2'
  sha1 'c2f20c75f6eedbaf4a3299e0e3fda2ef775092e8'

  depends_on 'pkg-config' => :build
  depends_on 'libgnomecanvas'
  depends_on 'gtkmm'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

end
