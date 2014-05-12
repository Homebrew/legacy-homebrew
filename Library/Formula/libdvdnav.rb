require 'formula'

class Libdvdnav < Formula
  homepage 'http://dvdnav.mplayerhq.hu/'
  url 'http://dvdnav.mplayerhq.hu/releases/libdvdnav-4.2.1.tar.xz'
  sha256 '7fca272ecc3241b6de41bbbf7ac9a303ba25cb9e0c82aa23901d3104887f2372'

  head 'git://git.videolan.org/libdvdnav.git'

  depends_on 'libdvdread'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool

  def install
    system "./autogen.sh", "--disable-debug", "--disable-dependency-tracking",
                           "--prefix=#{prefix}"
    system "make install"
  end
end
