class Tiff2png < Formula
  desc "TIFF to PNG converter"
  homepage "http://www.libpng.org/pub/png/apps/tiff2png.html"
  url "https://github.com/rillian/tiff2png/archive/v0.92.tar.gz"
  sha256 "64e746560b775c3bd90f53f1b9e482f793d80ea6e7f5d90ce92645fd1cd27e4a"

  bottle do
    cellar :any
    sha256 "3c97a9fd6dd98bb75f60ecd44059d2191d23614759b988002ed02e6d455670ce" => :yosemite
    sha256 "b6ff58f47124dfddfdeefb7e0326e22bbaff6a4955a55f860831a8d8eb83935e" => :mavericks
    sha256 "c087e255ae60a218f2d7e2368341bfa5176da0642bd3c2225ad6ca67055aca58" => :mountain_lion
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
