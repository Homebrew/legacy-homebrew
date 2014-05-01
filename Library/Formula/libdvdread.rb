require 'formula'

class Libdvdread < Formula
  homepage 'http://dvdnav.mplayerhq.hu/'
  url 'http://dvdnav.mplayerhq.hu/releases/libdvdread-4.2.0.tar.bz2'
  sha1 '431bc92195f27673bfdd2be67ce0f58338da8d3b'

  head 'svn://svn.mplayerhq.hu/dvdnav/trunk/libdvdread'

  bottle do
    cellar :any
    sha1 "106a8ccb669d128b24a318d2871034cab9cf885f" => :mavericks
    sha1 "38f197eb88ada23d51b92512331c116ded8a6137" => :mountain_lion
    sha1 "e93d6645e6118b8c4217c15f95d9476b14d1f3b2" => :lion
  end

  depends_on 'libdvdcss'

  depends_on :autoconf
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
