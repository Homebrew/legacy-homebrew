class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng16/libpng-1.6.21.tar.xz"
  mirror "https://dl.bintray.com/homebrew/mirror/libpng-1.6.21.tar.xz"
  sha256 "6c8f1849eb9264219bf5d703601e5abe92a58651ecae927a03d1a1aa15ee2083"

  bottle do
    cellar :any
    sha256 "5eef2e0b08d11bac515455e9f2addcff5ed77419c3fd98844158894b5bf4f794" => :el_capitan
    sha256 "9a2b6e64ff89535d0d63a0fde6248a05df3397205d0c24ae0175580b723c1385" => :yosemite
    sha256 "22b421d6d8034884fb0b697001b0965cb19f3b3a32c0c619ead86250e6f2a40d" => :mavericks
  end

  keg_only :provided_pre_mountain_lion

  head do
    url "https://github.com/glennrp/libpng.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <png.h>

      int main()
      {
        png_structp png_ptr;
        png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
        png_destroy_write_struct(&png_ptr, (png_infopp)NULL);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpng", "-o", "test"
    system "./test"
  end
end
