class Tiff2png < Formula
  desc "TIFF to PNG converter"
  homepage "http://www.libpng.org/pub/png/apps/tiff2png.html"
  url "https://github.com/rillian/tiff2png/archive/v0.92.tar.gz"
  sha256 "64e746560b775c3bd90f53f1b9e482f793d80ea6e7f5d90ce92645fd1cd27e4a"

  bottle do
    cellar :any
    sha1 "26a1789b8993f768a39e8b205b94fbc8f16605a3" => :yosemite
    sha1 "897b3ed4ae0529dc7d71992c2b36cd05586f5cd6" => :mavericks
    sha1 "5e91908ae45ce0dda0504465e31f8e0f610feac4" => :mountain_lion
  end

  depends_on "libtiff"
  depends_on "libpng"
  depends_on "jpeg"

  def install
    bin.mkpath
    system "make", "INSTALL=#{prefix}", "CC=#{ENV.cc}", "install"
  end

  test do
    system "#{bin}/tiff2png", test_fixtures("test.tiff")
  end
end
