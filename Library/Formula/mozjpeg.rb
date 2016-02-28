class Mozjpeg < Formula
  desc "Improved JPEG encoder"
  homepage "https://github.com/mozilla/mozjpeg"
  url "https://github.com/mozilla/mozjpeg/releases/download/v3.1/mozjpeg-3.1-release-source.tar.gz"
  sha256 "deedd88342c5da219f0047d9a290cd58eebe1b7a513564fcd8ebc49670077a1f"

  head do
    url "https://github.com/mozilla/mozjpeg.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    revision 1
    sha256 "3e588bc24506e4b4a15dad591c57b5f937c0bf0c830244b4a9980502bee6c0fd" => :el_capitan
    sha256 "b9b41960802e6a31de189de73d013c750317fb4b6b64cdab7fc40af8aaecb651" => :yosemite
    sha256 "4670747d1beb2e197386e7e07ecc6fa3087818d6c305d23b688487d0038faab7" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "nasm" => :build
  depends_on "libpng" => :optional

  keg_only "mozjpeg is not linked to prevent conflicts with the standard libjpeg."

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--with-jpeg8"
    system "make", "install"
  end

  test do
    system "#{bin}/jpegtran", "-crop", "1x1",
                              "-transpose", "-optimize",
                              "-outfile", "out.jpg",
                              test_fixtures("test.jpg")
  end
end
