class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "http://www.remotesensing.org/libtiff/"
  url "http://download.osgeo.org/libtiff/tiff-4.0.4.tar.gz"
  mirror "ftp://ftp.remotesensing.org/pub/libtiff/tiff-4.0.4.tar.gz"
  sha256 "8cb1d90c96f61cdfc0bcf036acc251c9dbe6320334da941c7a83cfe1576ef890"

  bottle do
    cellar :any
    sha256 "606ea5cbfeaf91a9cbe43197be60b8cf7327f2badfd196e45975ce35e56e1e1e" => :yosemite
    sha256 "9412670cd297d513720473b41c70cb8a03f8858f1b4e973ab3730f972273d553" => :mavericks
    sha256 "6b995d86477c041fed6cf63ef216f3adb48e13876b2fb06d6fd03c5526c137fc" => :mountain_lion
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
