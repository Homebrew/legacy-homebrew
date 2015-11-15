class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng16/libpng-1.6.19.tar.xz"
  mirror "https://dl.bintray.com/homebrew/mirror/libpng-1.6.19.tar.xz"
  sha256 "311c5657f53516986c67713c946f616483e3cdb52b8b2ee26711be74e8ac35e8"

  bottle do
    cellar :any
    sha256 "f3da66c378360052d2425885e6600e3e084aa1600b0dc0523d3f0dfd86db5c24" => :el_capitan
    sha256 "adb9d871ccff3ee90ccc1f5833e46b67eb7b637ca3a8e860c4e3f5c377a8e956" => :yosemite
    sha256 "39ba75af10d801cec077b3fc064b5011663cf4ad16cbbfe9b7f5c33fddef27e4" => :mavericks
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
