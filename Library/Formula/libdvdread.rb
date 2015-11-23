class Libdvdread < Formula
  desc "C library for reading DVD-video images"
  homepage "https://dvdnav.mplayerhq.hu/"
  url "https://download.videolan.org/pub/videolan/libdvdread/5.0.2/libdvdread-5.0.2.tar.bz2"
  sha256 "82cbe693f2a3971671e7428790b5498392db32185b8dc8622f7b9cd307d3cfbf"

  head do
    url "git://git.videolan.org/libdvdread.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    sha256 "678d4bf550fa4e1201086e3c85eb0bb8de6879e8aa69d8d8211d71b924842863" => :el_capitan
    sha1 "df466eb8a5baca8d26615d93d9eb3e88bf5ec6a8" => :yosemite
    sha1 "427e4c4a5553abbfba325837be969811496641bd" => :mavericks
    sha1 "3ad46154279902cb54890942f2d2ade6eeb32f7a" => :mountain_lion
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
