class Mozjpeg < Formula
  homepage "https://github.com/mozilla/mozjpeg"
  url "https://github.com/mozilla/mozjpeg/releases/download/v3.0/mozjpeg-3.0-release-source.tar.gz"
  sha1 "9b56af77ce376300e1f6de78b52b2ce9b6f19596"

  head do
    url "https://github.com/mozilla/mozjpeg.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    sha1 "d4c74518254db363f15b9c2211368eb3df856c33" => :yosemite
    sha1 "1141f9bbb67f3938a3c061bd3adcfc7b7d6a5710" => :mavericks
    sha1 "684bd946e018dbcd5968301805649ec20bc4a496" => :mountain_lion
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
