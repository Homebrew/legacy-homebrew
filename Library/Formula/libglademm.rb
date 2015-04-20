require 'formula'

class Libglademm < Formula
  homepage 'http://gnome.org'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libglademm/2.6/libglademm-2.6.7.tar.bz2'
  sha1 'd7c0138c80ea337d2e9ae55f74a6953ce2eb9f5d'

  bottle do
    cellar :any
    revision 1
    sha1 "b618a33313899fc7ed85097ed501358f06a40174" => :yosemite
    sha1 "ab0607b43ba9195b3f18fc38cdabd3a72d5c499c" => :mavericks
  end

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
