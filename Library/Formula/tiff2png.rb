class Tiff2png < Formula
  homepage "http://www.libpng.org/pub/png/apps/tiff2png.html"
  url "https://github.com/rillian/tiff2png/archive/v0.92.tar.gz"
  sha1 "b838d0e43410a237837b46654e3fb1644fd9891f"

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
