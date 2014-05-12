require 'formula'

class Libdvdread < Formula
  homepage 'http://dvdnav.mplayerhq.hu/'
  url 'http://download.videolan.org/pub/videolan/libdvdread/4.9.9/libdvdread-4.9.9.tar.bz2'
  sha256 'ffcf51c8596f5b052e95c50f2555d15f645d652b153afde2ab4c0733dde69fbb'

  head 'git://git.videolan.org/libdvdread.git'

  depends_on 'libdvdcss'

  def install
    ENV.append "CFLAGS", "-DHAVE_DVDCSS_DVDCSS_H"
    ENV.append "LDFLAGS", "-ldvdcss"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
