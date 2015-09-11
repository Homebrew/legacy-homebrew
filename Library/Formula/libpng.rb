class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  # Sourceforge tarball is not up yet; review this later
  url "ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng16/libpng-1.6.18.tar.xz"
  mirror "https://dl.bintray.com/homebrew/mirror/libpng-1.6.18.tar.xz"
  sha256 "2e10c13b7949883ac961db6177c516d778184432d440317e9f0391305c360963"

  bottle do
    cellar :any
    sha256 "5931c6bb64b53ada468e8b3afa4ae3585f13df0d3bd1d9eb2d68aa25f22ef366" => :el_capitan
    sha256 "016c6fe61a99dbdd1a90d198dff9a0d8bfb989bc7f909c4742bc6f44e3151789" => :yosemite
    sha256 "c083286e7643c581747d610ca73abb1fe1fea79f0125749fba21e789c898022c" => :mavericks
    sha256 "0a0b4d21eefcd12b49d55f623da46b8329543758746db1ea83e98b5cf4143833" => :mountain_lion
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
