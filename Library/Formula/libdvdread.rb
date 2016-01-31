class Libdvdread < Formula
  desc "C library for reading DVD-video images"
  homepage "https://dvdnav.mplayerhq.hu/"
  url "https://download.videolan.org/pub/videolan/libdvdread/5.0.3/libdvdread-5.0.3.tar.bz2"
  sha256 "321cdf2dbdc83c96572bc583cd27d8c660ddb540ff16672ecb28607d018ed82b"

  head do
    url "git://git.videolan.org/libdvdread.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    sha256 "ec4bf18e28993cb210722e2a15fb7c22297e219dfb94d910148c291af59bf6a3" => :el_capitan
    sha256 "1c77e1abc90ea979e77da169a6a91d1df11e234ac78516bb448486da048d2f01" => :yosemite
    sha256 "caf2bd44104c46195d80cfd4305c3c24856ff6d2a5018924eac84f9a2f2f8508" => :mavericks
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
