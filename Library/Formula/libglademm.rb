require 'formula'

class Libglademm < Formula
  homepage 'http://gnome.org'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libglademm/2.6/libglademm-2.6.7.tar.bz2'
  sha1 'd7c0138c80ea337d2e9ae55f74a6953ce2eb9f5d'

  depends_on 'pkg-config' => :build
  depends_on 'gtkmm'
  depends_on 'libglade'
  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
