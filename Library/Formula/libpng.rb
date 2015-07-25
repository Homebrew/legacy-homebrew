class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  # Sourceforge tarball is not up yet; review this later
  url "ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng16/libpng-1.6.18.tar.xz"
  sha256 "2e10c13b7949883ac961db6177c516d778184432d440317e9f0391305c360963"

  bottle do
    cellar :any
    sha256 "e1d3164a32a4be42bf6e18223e5046d65b2e1127a4cbd9d5907ba4fb9cee760e" => :yosemite
    sha256 "90bbba06eea26ccff46c1b5e679491841460ad5e090c0b9c2be90fcb54480005" => :mavericks
    sha256 "9b51c3ac3254ad327ed086be14761b87161e60279bc161faa3e7e9c718107c4b" => :mountain_lion
  end

  keg_only :provided_pre_mountain_lion

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
