class Libagar < Formula
  desc "Cross-platform GUI toolkit"
  homepage "http://libagar.org/"
  url "http://stable.hypertriton.com/agar/agar-1.4.1.tar.gz"
  sha256 "b0e62b754f134c3c0dd070a4fa62fa552654356eebab3d55e32d5d9b151a275e"
  head "http://dev.csoft.net/agar/trunk", :using => :svn

  depends_on "sdl"
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libpng"

  def install
    # Parallel builds failed to install config binaries
    # https://bugs.csoft.net/show_bug.cgi?id=223
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install", "MANDIR=#{man}" # --mandir for configure didn't work
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <agar/core.h>
      #include <agar/gui.h>

      int main() {
        AG_Window *win;
        if (AG_InitCore("test", AG_VERBOSE) == -1 || AG_InitGraphics(NULL) == -1) {
          return 1;
        } else {
          return 0;
        }
      }
    EOS
    flags = %W[
      -I#{include}/agar
      -I#{Formula["sdl"].opt_include}/SDL
      -I#{Formula["freetype"].opt_include}/freetype2
      -I#{Formula["libpng"].opt_include}/libpng
      -L#{lib}
      -L#{Formula["sdl"].opt_lib}
      -L#{Formula["freetype"].opt_lib}
      -L#{Formula["libpng"].opt_lib}
      -lag_core
      -lag_gui
      -lSDLmain
      -lSDL
      -lfreetype
      -lpng16
      -ljpeg
      -Wl,-framework,Cocoa,-framework,OpenGL
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
