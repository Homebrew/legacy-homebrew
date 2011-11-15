require 'formula'

class Libdvdread < Formula
  homepage 'http://dvdnav.mplayerhq.hu/'
  url 'http://dvdnav.mplayerhq.hu/releases/libdvdread-4.2.0.tar.bz2'
  head 'svn://svn.mplayerhq.hu/dvdnav/trunk/libdvdread'
  md5 'ab7a19d3ab1a437ae754ef477d6231a4'

  depends_on 'libdvdcss' => :optional

  def install
    if Formula.factory("libdvdcss").installed?
      ENV.append "CFLAGS", "-DHAVE_DVDCSS_DVDCSS_H"
      ENV.append "LDFLAGS", "-ldvdcss"
    end

    system "./autogen.sh", "--disable-debug", "--disable-dependency-tracking",
                           "--prefix=#{prefix}"
    system "make install"
  end
end
