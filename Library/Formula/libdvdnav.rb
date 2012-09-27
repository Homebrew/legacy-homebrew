require 'formula'

class Libdvdnav < Formula
  homepage 'http://dvdnav.mplayerhq.hu/'
  url 'http://dvdnav.mplayerhq.hu/releases/libdvdnav-4.2.0.tar.bz2'
  head 'svn://svn.mplayerhq.hu/dvdnav/trunk/libdvdnav'
  sha1 'ded45d985576169ae3630d8be7179a2323bc0f6f'

  depends_on 'libdvdread'

  depends_on :automake
  depends_on :libtool

  def install
    system "./autogen.sh", "--disable-debug", "--disable-dependency-tracking",
                           "--prefix=#{prefix}"
    system "make install"
  end
end
