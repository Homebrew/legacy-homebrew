class Libpng < Formula
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sf.net/project/libpng/libpng16/1.6.16/libpng-1.6.16.tar.xz"
  sha1 "31855a8438ae795d249574b0da15b34eb0922e13"

  bottle do
    cellar :any
    sha1 "f7b47fcf9d4111075745b04b6fbdb63062982bca" => :yosemite
    sha1 "b67793bae0a5d109be5ad19d27bbeb4509f4ecee" => :mavericks
    sha1 "a2fb283d2f96161ecee5d504adb92b26376b7d9e" => :mountain_lion
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
