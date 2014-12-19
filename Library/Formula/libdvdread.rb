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
    revision 1
    sha1 "480edcd6846116214826c578ce3666d2b8cc88b7" => :yosemite
    sha1 "8420a9c3ec271d24d7e5d4b9748ebe47ae01a978" => :mavericks
    sha1 "006a3b659db6be7d8e4a9f641deb6d7fca065ecb" => :mountain_lion
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
