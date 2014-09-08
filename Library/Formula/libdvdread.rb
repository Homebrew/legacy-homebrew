require 'formula'

class Libdvdread < Formula
  homepage 'http://dvdnav.mplayerhq.hu/'
  url 'http://download.videolan.org/pub/videolan/libdvdread/4.9.9/libdvdread-4.9.9.tar.bz2'
  sha256 'ffcf51c8596f5b052e95c50f2555d15f645d652b153afde2ab4c0733dde69fbb'

  head 'git://git.videolan.org/libdvdread.git'

  bottle do
    cellar :any
    sha1 "e40c9798dfce20ff381e86aa248c40ad2b4dc54f" => :mavericks
    sha1 "dfc52def86101b04cca9d0153efc87986944bfbd" => :mountain_lion
    sha1 "35be8214b84e4556d6cb78513a77333ab04d85e0" => :lion
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
