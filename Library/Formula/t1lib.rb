class T1lib < Formula
  desc "C library to generate/rasterize bitmaps from Type 1 fonts"
  homepage "http://www.t1lib.org/"
  url "https://www.ibiblio.org/pub/linux/libs/graphics/t1lib-5.1.2.tar.gz"
  mirror "ftp://ftp.ibiblio.org/pub/linux/libs/graphics/t1lib-5.1.2.tar.gz"
  sha256 "821328b5054f7890a0d0cd2f52825270705df3641dbd476d58d17e56ed957b59"

  bottle do
    revision 1
    sha256 "3e1e05aaf56a7b1569faaab30f6281d79958cd1dc230d4a94aff77ae88500ac6" => :yosemite
    sha256 "1cbdcf850c4dbcdefff6e25843c84ff08cf1e03d70744920cb35a9fff68b38a5" => :mavericks
    sha256 "01be2a73a4870445f2a612b99126b66804d53fdbf24a95e49b117ebf58427a66" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "without_doc"
    system "make", "install"
    share.install "Fonts" => "fonts"
  end
end
