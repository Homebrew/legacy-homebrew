class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "http://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.44/glibmm-2.44.0.tar.xz"
  sha256 "1b0ac0425d24895507c0e0e8088a464c7ae2d289c47afa1c11f63278fc672ea8"

  bottle do
    cellar :any
    revision 1
    sha256 "45187c701fdee69aa16b8b0b1c7b03cd028f9ff2381f2f141d83acdf4c80ac5d" => :el_capitan
    sha256 "61af2fe3799a6728f8d20834175e266afbbd75b544edf92db93415c340e916dd" => :yosemite
    sha256 "cce003756f83b8f2b7895602142ba537935c1d76149cb97a1de18b3f302c7c1d" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libsigc++"
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <glibmm.h>

      int main(int argc, char *argv[])
      {
         Glib::ustring my_string("testing");
         return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libsigcxx = Formula["libsigc++"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/glibmm-2.4
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/glibmm-2.4/include
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lintl
      -lsigc-2.0
    ]
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
