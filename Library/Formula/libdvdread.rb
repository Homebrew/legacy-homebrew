require "formula"

class Libdvdread < Formula
  homepage "https://dvdnav.mplayerhq.hu/"
  url "http://download.videolan.org/pub/videolan/libdvdread/5.0.0/libdvdread-5.0.0.tar.bz2"
  sha256 "66fb1a3a42aa0c56b02547f69c7eb0438c5beeaf21aee2ae2c6aa23ea8305f14"

  head do
    url "git://git.videolan.org/libdvdread.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    sha1 "e40c9798dfce20ff381e86aa248c40ad2b4dc54f" => :mavericks
    sha1 "dfc52def86101b04cca9d0153efc87986944bfbd" => :mountain_lion
    sha1 "35be8214b84e4556d6cb78513a77333ab04d85e0" => :lion
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
