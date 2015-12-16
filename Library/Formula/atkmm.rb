class Atkmm < Formula
  desc "Official C++ interface for the ATK accessibility toolkit library"
  homepage "http://www.gtkmm.org"
  url "https://download.gnome.org/sources/atkmm/2.24/atkmm-2.24.2.tar.xz"
  sha256 "ff95385759e2af23828d4056356f25376cfabc41e690ac1df055371537e458bd"

  bottle do
    cellar :any
    sha256 "70c5c9652b337efe41f26d61480dad331095a6ded8cae26bc8dc0066c06adfb5" => :el_capitan
    sha256 "a7ddfcacea2a645a939c0eb7b5d2c026d9f9af9ba3e579ee66df28fbe6339879" => :yosemite
    sha256 "a39942b931ea636033cd6018ddbe25d050dbcdda5ef80f0c9d9cc81a7d9636d4" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "glibmm"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <atkmm/init.h>

      int main(int argc, char *argv[])
      {
         Atk::init();
         return 0;
      }
    EOS
    atk = Formula["atk"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    glibmm = Formula["glibmm"]
    libsigcxx = Formula["libsigc++"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{glibmm.opt_include}/glibmm-2.4
      -I#{glibmm.opt_lib}/glibmm-2.4/include
      -I#{include}/atkmm-1.6
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -L#{atk.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{glibmm.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -latk-1.0
      -latkmm-1.6
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lintl
      -lsigc-2.0
    ]
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
