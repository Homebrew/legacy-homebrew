class Libicns < Formula
  desc "Library for manipulation of the OS X .icns resource format"
  homepage "http://icns.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/icns/libicns-0.8.1.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/libi/libicns/libicns_0.8.1.orig.tar.gz"
  sha256 "335f10782fc79855cf02beac4926c4bf9f800a742445afbbf7729dab384555c2"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "0a4ca09b65f56649ee13e247026b76d558c6f4530f74871149f50b42221f645e" => :el_capitan
    sha256 "a3bd011b7b3b8aa29e4ef98eab0c15438e88447a3be984af671341db1856f538" => :yosemite
    sha256 "df6b2e2eaa0e647706073e4523a41b8df32b192b12d671255d7c2009a9900559" => :mavericks
    sha256 "4a64274683702dac5e144715cfa1f372b6625df5f69d357253999c1bde838e0f" => :mountain_lion
  end

  option :universal

  depends_on "jasper"
  depends_on "libpng"

  def install
    # Fix for libpng 1.5
    inreplace "icnsutils/png2icns.c",
      "png_set_gray_1_2_4_to_8",
      "png_set_expand_gray_1_2_4_to_8"

    ENV.universal_binary if build.universal?

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include "icns.h"
      int main(void)
      {
        int    error = 0;
        FILE            *inFile = NULL;
        icns_family_t  *iconFamily = NULL;
        icns_image_t  iconImage;
        return 0;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-licns", testpath/"test.c", "-o", "test"
    system "./test"
  end
end
