require 'formula'

class Atk < Formula
  homepage 'http://library.gnome.org/devel/atk/'
  url 'http://ftp.gnome.org/pub/gnome/sources/atk/2.0/atk-2.0.1.tar.bz2'
  sha256 '3d81c7d70fc66e5b129567a7706b6f8ff5db18281a818b29d4dd5bcefa3d4a17'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-glibtest"
    system "make install"
  end
end
