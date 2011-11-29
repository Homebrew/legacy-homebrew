require 'formula'

class Libdvdnav < Formula
  homepage 'http://dvdnav.mplayerhq.hu/'
  url 'http://dvdnav.mplayerhq.hu/releases/libdvdnav-4.2.0.tar.bz2'
  head 'svn://svn.mplayerhq.hu/dvdnav/trunk/libdvdnav'
  md5 '53be8903f9802e101929a3451203bbf6'

  depends_on 'libdvdread'

  def install
    system "./autogen.sh", "--disable-debug", "--disable-dependency-tracking",
                           "--prefix=#{prefix}"
    system "make install"
  end
end
