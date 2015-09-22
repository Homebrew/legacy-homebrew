class Atkmm < Formula
  desc "Official C++ interface for the ATK accessibility toolkit library"
  homepage "http://www.gtkmm.org"
  url "https://download.gnome.org/sources/atkmm/2.24/atkmm-2.24.1.tar.xz"
  sha256 "26c41d8da37d04eef9f219c6ce87d94852e1cacaad823050e520e1c08a36ed23"

  bottle do
    sha1 "6c47047d111b4b950e1cb15425365b13b11f6a1b" => :mavericks
    sha1 "2262b36b562f9f2ea1c024923e738a08145e97df" => :mountain_lion
    sha1 "eb053cdcba6fc56e0bddde08ac356a18d9bf53b0" => :lion
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
