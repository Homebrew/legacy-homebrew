class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "http://www.remotesensing.org/libtiff/"
  url "http://download.osgeo.org/libtiff/tiff-4.0.6.tar.gz"
  mirror "ftp://ftp.remotesensing.org/pub/libtiff/tiff-4.0.6.tar.gz"
  sha256 "4d57a50907b510e3049a4bba0d7888930fdfc16ce49f1bf693e5b6247370d68c"

  bottle do
    cellar :any
    sha256 "672ea454a8c5ec6b5622f8c2d427b5631c195a811f47f05005187ff43e8e946b" => :el_capitan
    sha256 "c5adb753b7f5c9be0d139612181e7f18eb4b0c3ebfe5b30498eaee67a1f2adb8" => :yosemite
    sha256 "16a8966728b4b2ec9827917465fe26ba91d02160dfc2d9fc627752c3658a2a22" => :mavericks
    sha256 "53b181e29cfa565a928cac933dc4119a66acab59a38d5149af687c05ad557508" => :mountain_lion
  end

  option :universal
  option :cxx11

  depends_on "jpeg"

  def install
    ENV.universal_binary if build.universal?
    ENV.cxx11 if build.cxx11?
    jpeg = Formula["jpeg"].opt_prefix
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x",
                          "--disable-lzma",
                          "--with-jpeg-include-dir=#{jpeg}/include",
                          "--with-jpeg-lib-dir=#{jpeg}/lib"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <tiffio.h>

      int main(int argc, char* argv[])
      {
        TIFF *out = TIFFOpen(argv[1], "w");
        TIFFSetField(out, TIFFTAG_IMAGEWIDTH, (uint32) 10);
        TIFFClose(out);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ltiff", "-o", "test"
    system "./test", "test.tif"
    assert_match /ImageWidth.*10/, shell_output("#{bin}/tiffdump test.tif")
  end
end
