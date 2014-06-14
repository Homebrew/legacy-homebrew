require 'formula'

class Libdvdnav < Formula
  homepage 'http://dvdnav.mplayerhq.hu/'
  url 'http://dvdnav.mplayerhq.hu/releases/libdvdnav-4.2.1.tar.xz'
  sha256 '7fca272ecc3241b6de41bbbf7ac9a303ba25cb9e0c82aa23901d3104887f2372'

  head 'git://git.videolan.org/libdvdnav.git'

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libdvdread"

  def install
    system "./autogen.sh", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
