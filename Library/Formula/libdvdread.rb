class Libdvdread < Formula
  desc "C library for reading DVD-video images"
  homepage "https://dvdnav.mplayerhq.hu/"
  url "https://download.videolan.org/pub/videolan/libdvdread/5.0.3/libdvdread-5.0.3.tar.bz2"
  sha256 "321cdf2dbdc83c96572bc583cd27d8c660ddb540ff16672ecb28607d018ed82b"

  head do
    url "https://git.videolan.org/git/libdvdread.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    revision 1
    sha256 "9de98e88e99fbcc899a299786575472c93d442b06838f16bb757e09d4ba92593" => :el_capitan
    sha256 "75006f367876e6ccce744d782f1204ea99d73b55a856ce0afaae2c194eac336c" => :yosemite
    sha256 "79b919acd8c54956680272a32b106882f90027ce148e54eb937b367564b51e87" => :mavericks
  end

  depends_on "libdvdcss"

  def install
    ENV.append "CFLAGS", "-DHAVE_DVDCSS_DVDCSS_H"
    ENV.append "LDFLAGS", "-ldvdcss"

    system "autoreconf", "-if" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
