require 'formula'

class Libxmlxx < Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/libxml++/2.33/libxml++-2.33.2.tar.gz'
  homepage 'http://libxmlplusplus.sourceforge.net'
  md5 '219f8c8e3bb3af9f9a012fffc82a642a'

  depends_on 'glibmm'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
