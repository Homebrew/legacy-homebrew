require 'formula'

class Libglademm < Formula
  homepage 'http://gnome.org'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libglademm/2.6/libglademm-2.6.7.tar.bz2'
  md5 'f9ca5b67f6c551ea98790ab5f21c19d0'

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
