class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng16/libpng-1.6.21.tar.xz"
  mirror "https://dl.bintray.com/homebrew/mirror/libpng-1.6.21.tar.xz"
  sha256 "6c8f1849eb9264219bf5d703601e5abe92a58651ecae927a03d1a1aa15ee2083"

  bottle do
    cellar :any
    sha256 "4023b605e1c069b8d39be040146421117bf8a5f2941fe8be86a336515063b6f6" => :el_capitan
    sha256 "4a158dee6cba61cf2323eb7ab8057a1c5010ec0d171cdf84fd4ad63a0d20a53f" => :yosemite
    sha256 "643e1f885dace0091fb6c717f7d64d415f29dda1d97c2f94937ae8c0bf1a3f4c" => :mavericks
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
