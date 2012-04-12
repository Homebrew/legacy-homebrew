require 'formula'

class Libxmlxx < Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/libxml++/2.34/libxml++-2.34.2.tar.bz2'
  homepage 'http://libxmlplusplus.sourceforge.net'
  sha256 '38f20632a711d06166b03a2a92ce71b08130ac30e014805a7052ae3f4c0b15e8'

  depends_on 'glibmm'
  # LibXML++ can't compile agains the version of LibXML shipped with Leopard
  depends_on 'libxml2' if MacOS.leopard?

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
