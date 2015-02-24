class Libtiff < Formula
  homepage "http://www.remotesensing.org/libtiff/"
  url "ftp://ftp.remotesensing.org/pub/libtiff/tiff-4.0.3.tar.gz"
  mirror "http://download.osgeo.org/libtiff/tiff-4.0.3.tar.gz"
  sha256 "ea1aebe282319537fb2d4d7805f478dd4e0e05c33d0928baba76a7c963684872"

  bottle do
    cellar :any
    sha1 "888fa993035b5af4b62daa6cf63c2b06988f4f8e" => :yosemite
    sha1 "8e2a7f7509689733c0762e01410e247b7ccb98af" => :mavericks
    sha1 "611e3478187bbcdb5f35970914ee4fe269aeb585" => :mountain_lion
    sha1 "889158ea146de39f42a489b18af4321004cd54d8" => :lion
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
    system ENV.cc, "test.c", "-ltiff", "-o", "test"
    system "./test", "test.tif"
    assert_match /ImageWidth.*10/, shell_output("#{bin}/tiffdump test.tif")
  end
end
