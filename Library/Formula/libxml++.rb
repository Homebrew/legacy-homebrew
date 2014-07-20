require 'formula'

class Libxmlxx < Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/libxml++/2.34/libxml++-2.34.2.tar.bz2'
  homepage 'http://libxmlplusplus.sourceforge.net'
  sha256 '38f20632a711d06166b03a2a92ce71b08130ac30e014805a7052ae3f4c0b15e8'

  bottle do
    sha1 "13bf9fa17e6fe7020e69663ce66624f077c8bcd0" => :mavericks
    sha1 "642dd5375d0171c68accd93030e72b4f617f376b" => :mountain_lion
    sha1 "ba6b90c9d92c0c649f5484f273ce098040f35b0a" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'glibmm'
  # LibXML++ can't compile agains the version of LibXML shipped with Leopard
  depends_on 'libxml2' if MacOS.version <= :leopard

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
