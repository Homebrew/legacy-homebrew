class Gtkextra < Formula
  homepage "http://gtkextra.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gtkextra/3.1/gtkextra-3.1.2.tar.gz"
  sha1 "f3c85b7edb3980ae2390d951d62c24add4b45eb9"

  bottle do
    cellar :any
    sha1 "6ff80fc1fdcc15aad24dbba2428006d2cb6ef491" => :yosemite
    sha1 "0854acd0dd2d38123a2aa98c7e4449e89c532900" => :mavericks
    sha1 "a8d200588c69a98b063b16426cc49f29c549cf4a" => :mountain_lion
  end

  # uses whatever backend gtk+ is built with: x11 or quartz
  depends_on "gtk+"
  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-tests",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    ENV.prepend "PKG_CONFIG_PATH", OS::Mac::X11.lib/"pkgconfig"
    (testpath/"test.c").write <<-EOS.undent
    #include <gtkextra/gtkextra.h>
    int main(int argc, char *argv[]) {
      GtkWidget *canvas = gtk_plot_canvas_new(GTK_PLOT_A4_H, GTK_PLOT_A4_W, 0.8);
      return 0;
    }

    EOS
    cflags = `pkg-config --cflags gtkextra-3.0`.chomp.split
    libs = `pkg-config --libs gtkextra-3.0`.chomp.split
    system ENV.cc, "-o", "test", "test.c", *(cflags+libs)
    system "./test"
  end
end
