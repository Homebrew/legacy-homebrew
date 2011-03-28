require 'formula'

class Atk < Formula
  homepage 'http://library.gnome.org/devel/atk/'
  url 'ftp://ftp.gnome.org/pub/gnome/sources/atk/1.32/atk-1.32.0.tar.bz2'
  sha256 'e9a3e598f75c4db1af914f8b052dd9f7e89e920a96cc187c18eb06b8339cb16e'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-glibtest"
    system "make install"
  end
end
