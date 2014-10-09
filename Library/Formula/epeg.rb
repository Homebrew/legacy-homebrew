require "formula"

class Epeg < Formula
  homepage "https://github.com/mattes/epeg"
  url "https://github.com/mattes/epeg/archive/v0.9.1.042.tar.gz"
  sha1 "51ef8a55c9567e75c64bf3390fe7c92aa76ac306"

  head "https://github.com/mattes/epeg.git"

  depends_on "automake" => :build
  depends_on "jpeg"
  depends_on "libexif"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "epeg", "--width=1",
                   "--height=1",
                   test_fixtures("test.jpg")
                   "out.jpg"
  end
end
