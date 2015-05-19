class Libxmlxx < Formula
  desc "C++ wrapper for libxml"
  homepage "http://libxmlplusplus.sourceforge.net"
  url "https://download.gnome.org/sources/libxml++/2.38/libxml++-2.38.0.tar.xz"
  sha256 "5698b03f5d320fb8310e30780e328f03debca12c557434ee031aea9baf3b1346"

  bottle do
    sha256 "a54f1940bdcf03e3198a1907ffcad9ce66d0dd1fc79babf502c5100ede9e0703" => :yosemite
    sha256 "3837069e7c317cab4df180451a7f74c7dd730fad068309ae394f684e2ed38988" => :mavericks
    sha256 "0627acae7aa558085839566d36da0cedef39087c08e32bf7d39d8bb4c7260a53" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glibmm"
  # LibXML++ can't compile agains the version of LibXML shipped with Leopard
  depends_on "libxml2" if MacOS.version <= :leopard

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <libxml++/libxml++.h>

      int main(int argc, char *argv[])
      {
         xmlpp::Document document;
         document.set_internal_subset("homebrew", "", "http://www.brew.sh/xml/test.dtd");
         xmlpp::Element *rootnode = document.create_root_node("homebrew");
         return 0;
      }
    EOS
    ENV.libxml2
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    glibmm = Formula["glibmm"]
    libsigcxx = Formula["libsigc++"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{glibmm.opt_include}/glibmm-2.4
      -I#{glibmm.opt_lib}/glibmm-2.4/include
      -I#{include}/libxml++-2.6
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/libxml++-2.6/include
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{glibmm.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lintl
      -lsigc-2.0
      -lxml++-2.6
      -lxml2
    ]
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
