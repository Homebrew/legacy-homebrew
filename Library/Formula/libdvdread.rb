require 'formula'

class Libdvdread < Formula
  homepage 'http://dvdnav.mplayerhq.hu/'
  url 'http://dvdnav.mplayerhq.hu/releases/libdvdread-4.2.0.tar.bz2'
  sha1 '431bc92195f27673bfdd2be67ce0f58338da8d3b'

  head 'svn://svn.mplayerhq.hu/dvdnav/trunk/libdvdread'

  depends_on 'libdvdcss'

  depends_on :automake
  depends_on :libtool

  def install
    ENV.append "CFLAGS", "-DHAVE_DVDCSS_DVDCSS_H"
    ENV.append "LDFLAGS", "-ldvdcss"

    system "./autogen.sh", "--disable-dependency-tracking",
                           "--prefix=#{prefix}"
    system "make install"
  end
end
