class Pixman < Formula
  desc "Low-level library for pixel manipulation"
  homepage "http://cairographics.org/"
  url "http://cairographics.org/releases/pixman-0.32.6.tar.gz"
  sha256 "3dfed13b8060eadabf0a4945c7045b7793cc7e3e910e748a8bb0f0dc3e794904"

  bottle do
    cellar :any
    revision 2
    sha256 "377f9b602abd3f1ba92c0cce5671e12aaf8815b07882a09c5f61e6774bc4c686" => :el_capitan
    sha256 "3a5221db33dcb4684bbae580a7f2c58f532cb936126481ad8a13c72935049367" => :yosemite
    sha256 "4e65fd79c76a05313bfc16d2e1ae28f60f82f0fb6909f1c9769d09e61e6562d0" => :mavericks
    sha256 "074a35377da2e6637fbafde6d2221ac1ae73af7d24e50398be192cd6847dd670" => :mountain_lion
  end

  option :universal

  depends_on "pkg-config" => :build

  keg_only :provided_pre_mountain_lion

  fails_with :llvm do
    build 2336
    cause <<-EOS.undent
      Building with llvm-gcc causes PDF rendering issues in Cairo.
      https://trac.macports.org/ticket/30370
      See Homebrew issues #6631, #7140, #7463, #7523.
      EOS
  end

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-gtk",
                          "--disable-mmx", # MMX assembler fails with Xcode 7
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <pixman.h>

      int main(int argc, char *argv[])
      {
        pixman_color_t white = { 0xffff, 0xffff, 0xffff, 0xffff };
        pixman_image_t *image = pixman_image_create_solid_fill(&white);

        pixman_image_unref(image);
      }
    EOS
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{include}/pixman-1
      -L#{lib}
      -lpixman-1
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
