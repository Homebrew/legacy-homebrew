require 'formula'

class Libdvdread < Formula
  homepage 'http://dvdnav.mplayerhq.hu/'
  url 'http://download.videolan.org/pub/videolan/libdvdread/4.9.9/libdvdread-4.9.9.tar.bz2'
  sha256 'ffcf51c8596f5b052e95c50f2555d15f645d652b153afde2ab4c0733dde69fbb'

  head 'git://git.videolan.org/libdvdread.git'

  bottle do
    cellar :any
    sha1 "106a8ccb669d128b24a318d2871034cab9cf885f" => :mavericks
    sha1 "38f197eb88ada23d51b92512331c116ded8a6137" => :mountain_lion
    sha1 "e93d6645e6118b8c4217c15f95d9476b14d1f3b2" => :lion
  end

  depends_on 'libdvdcss'

  def install
    ENV.append "CFLAGS", "-DHAVE_DVDCSS_DVDCSS_H"
    ENV.append "LDFLAGS", "-ldvdcss"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
