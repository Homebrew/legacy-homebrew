class Pixman < Formula
  desc "Low-level library for pixel manipulation"
  homepage "http://cairographics.org/"
  url "http://cairographics.org/releases/pixman-0.32.8.tar.gz"
  sha256 "575ade17c40b47d391b02b4c0c63531c897b31e70046c96749514b7d8800d65d"

  bottle do
    cellar :any
    sha256 "80953a126df4a7d752f40964e83241f048d00d599e7419f792aa4d373a07c062" => :el_capitan
    sha256 "b397c8e7a7708d84d9b6b144a46045ed4cf91ed05c9d402dddfb3c5994e2e601" => :yosemite
    sha256 "a920c48cbb14c093478612e10abdead4888363b8dbdaaeab7ef0bc31c09f9134" => :mavericks
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
